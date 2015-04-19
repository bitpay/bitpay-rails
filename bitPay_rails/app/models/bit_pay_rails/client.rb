require 'bitpay_sdk'

module BitPayRails
  class Client < ActiveRecord::Base
    before_create :make_pem

    def make_pem
      key = ActiveSupport::KeyGenerator.new("IGuessI'llFigureThisOutLater").generate_key("getitworking")
      crypt = ActiveSupport::MessageEncryptor.new(key)
      pem = BitPay::KeyUtils.generate_pem
      self.pem = crypt.encrypt_and_sign(pem)
    end

    def get_pairing_code(params = {})
      params[:facade] = self.facade
      bp_token = new_client.pair_client(params)
      bp_token[0]['pairingCode']
    end

    def create_invoice(params = {})
      price, currency = params.delete(:price), params.delete(:currency)
      new_client.create_invoice(price: price, currency: currency, facade: self.facade, params: params)
    end

    def get_invoice(params = {})
      new_client.get_invoice(params)
    end
    
    def refund_invoice(params = {})
      invoice_id = params.delete(:id)
      new_client.refund_invoice(id: invoice_id, params: params)
    end

    def get_all_refunds_for_invoice(params = {})
      id = params[:id]
      new_client.get_all_refunds_for_invoice(id: id)
    end

    def get_refund(params = {})
      invoice_id, request_id = params[:invoice_id], params[:request_id]
      new_client.get_refund(invoice_id: invoice_id, request_id: request_id)
    end

    def cancel_refund(params = {})
      invoice_id, request_id = params[:invoice_id], params[:request_id]
      new_client.cancel_refund(invoice_id: invoice_id, request_id: request_id)
    end

    private

    def new_client
      BitPay::SDK::Client.new(api_uri: self.api_uri, pem: get_pem)
    end

    def get_pem
      key = ActiveSupport::KeyGenerator.new("IGuessI'llFigureThisOutLater").generate_key("getitworking")
      crypt = ActiveSupport::MessageEncryptor.new(key)
      pem = crypt.decrypt_and_verify(self.pem)
      pem
    end
  end
end
