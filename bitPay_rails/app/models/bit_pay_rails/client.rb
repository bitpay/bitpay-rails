module BitPayRails
  class Client < ActiveRecord::Base
    attr_encrypted :pem, :key => ENV['BITPAYRAILS_KEY']
    has_one :token
  end
end
