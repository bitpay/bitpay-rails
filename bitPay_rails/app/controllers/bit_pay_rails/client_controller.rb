require_dependency "bit_pay_rails/application_controller"

module BitPayRails
  class ClientController < ApplicationController
    def create
      @client = Client.new()
    end
  end
end
