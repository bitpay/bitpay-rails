module BitPayRails
  class Token < ActiveRecord::Base
    attr_encrypted :token, :key => ENV['BITPAYRAILS_KEY']
    belongs_to :client
  end
end
