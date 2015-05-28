require 'bitpay_sdk'

class BitPayClient < ActiveRecord::Base
  before_create :make_pem


  def get_pairing_code(params = {})
    params[:facade] = self.facade
    bp_token = tell_client(:pair_client, params)
    bp_token[0]['pairingCode']
  end

  def create_invoice(params = {})
    price, currency = params.delete(:price), params.delete(:currency)
    tell_client(:create_invoice, price: price, currency: currency, facade: self.facade, params: params)
  end

  def get_invoice(params = {})
    tell_client(:get_invoice, params)
  end

  def refund_invoice(params = {})
    invoice_id = params.delete(:id)
    tell_client(:refund_invoice, id: invoice_id, params: params)
  end

  def get_all_refunds_for_invoice(params = {})
    id = params[:id]
    tell_client(:get_all_refunds_for_invoice, id: id)
  end

  def get_refund(params = {})
    invoice_id, request_id = params[:invoice_id], params[:request_id]
    tell_client(:get_refund, invoice_id: invoice_id, request_id: request_id)
  end

  def cancel_refund(params = {})
    invoice_id, request_id = params[:invoice_id], params[:request_id]
    tell_client(:cancel_refund, invoice_id: invoice_id, request_id: request_id)
  end

  private

  def make_pem
    key, crypt = key_and_crypt
    pem = BitPay::KeyUtils.generate_pem
    self.pem = crypt.encrypt_and_sign(pem)
  end

  def tell_client(method, *args)
    begin
      new_client.send(method, *args)
    rescue Exception => e
      error = ("#{e.class}, #{e.message}")
      logger.error(error)
      return (error)
    end
  end

  def new_client
    params = {api_uri: self.api_uri, pem: get_pem}
    params[:insecure] = true if (Rails.env == "development" || Rails.env == "test")
    BitPay::SDK::Client.new(params)
  end

  def get_pem
    key, crypt = key_and_crypt
    pem = crypt.decrypt_and_verify(self.pem)
    pem
  end

  def key_and_crypt
    key = ActiveSupport::KeyGenerator.new(ENV['BPSECRET']).generate_key(ENV['BPSALT'])
    crypt = ActiveSupport::MessageEncryptor.new(key)
    return key, crypt
  end
end

