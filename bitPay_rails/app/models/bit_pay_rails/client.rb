require 'bitpay_key_utils'

module BitPayRails
  class Client < ActiveRecord::Base
    before_create :make_pem

    def make_pem
      key = ActiveSupport::KeyGenerator.new("IGuessI'llFigureThisOutLater").generate_key("getitworking")
      crypt = ActiveSupport::MessageEncryptor.new(key)
      pem = BitPay::KeyUtils.generate_pem
      self.pem = crypt.encrypt_and_sign(pem)
    end

    def get_pem
      pem_retriever
    end

    private
    def pem_retriever
      key = ActiveSupport::KeyGenerator.new("IGuessI'llFigureThisOutLater").generate_key("getitworking")
      crypt = ActiveSupport::MessageEncryptor.new(key)
      pem = crypt.decrypt_and_verify(self.pem)
      pem
    end
  end
end
