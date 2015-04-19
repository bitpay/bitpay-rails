class SetDefaultFacade < ActiveRecord::Migration
  def change
    change_column_default :bit_pay_rails_clients, :facade, "merchant"
  end
end
