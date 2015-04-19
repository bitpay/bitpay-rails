require 'test_helper'
require 'minitest/autorun'
require 'minitest/mock'

module BitPayRails
  class ClientTest < ActiveSupport::TestCase
    def setup
      @client = BitPayRails::Client.new(api_uri: "https://this.is")
      @client.save!
      @pem = @client.send(:get_pem)
      @mock_client = double("BitPay::SDK::Client") 
      allow(BitPay::SDK::Client).to receive(:new).with(api_uri: "https://this.is", pem: @pem).and_return(@mock_client)
    end

    test "client uses bitpay client to retrieve token" do
      allow(@mock_client).to receive(:pair_client).and_return([
        {"policies"=>[{"policy"=>"id", "method"=>"inactive", "params"=>["TfHzWm98MfsjyNAhF2cjeYvQiwamBSM1wFQ"]}],
         "token"=>"AZCfNBFtSx593kjGSaRqwTJCWgSJFAGwrMUwzTY5c5gw",
         "dateCreated"=>1429386951019,
         "pairingExpiration"=>1429473351019,
         "pairingCode"=>"5bvUecC"}])
      pairing_code = @client.get_pairing_code()
      assert_equal pairing_code, "5bvUecC"
    end

    test 'client uses bitpay client to create invoice' do
      expect(@mock_client).to receive(:create_invoice).with(price: 200, currency: "USD", facade: "merchant", params: {param1: 'a value', param2: 'b value'})
      params = {price: 200, currency: "USD", param1: "a value", param2: "b value"}
      @client.create_invoice(params)
    end

    test 'client call bitpay client to get invoice' do
      expect(@mock_client).to receive(:get_invoice).with(id: "aninvoiceid")
      params = {id: "aninvoiceid"}
      @client.get_invoice(params)
    end

    test 'client calls bitpay client to refund invoice' do
      expect(@mock_client).to receive(:refund_invoice).with(id: "invoiceid", params: {this: "that", the: "other"})
      params = {id: "invoiceid", this: "that", the: "other"}
      @client.refund_invoice(params)
    end

    test 'client calls bitpay client to get all refuns for invoice' do
      expect(@mock_client).to receive(:get_all_refunds_for_invoice).with(id: "idinvoice")
      params = {id: "idinvoice", notincluded: "notincluded"}
      @client.get_all_refunds_for_invoice(params)
    end

    test 'client calls bitpay client to get a specific refund for an invoice' do
      expect(@mock_client).to receive(:get_refund).with(invoice_id: 'invoiceid', request_id: 'refundid')
      params = {invoice_id: 'invoiceid', request_id: 'refundid', ignored: 'ignoreme'}
      @client.get_refund(params)
    end

    test 'client calls bitpay client to cancel refunds' do
      expect(@mock_client).to receive(:cancel_refund).with(invoice_id: 'invoiceid', request_id: 'refundid')
      params = {invoice_id: 'invoiceid', request_id: 'refundid', ignored: 'ignoreme'}
      @client.cancel_refund(params)
    end
  end
    
end
