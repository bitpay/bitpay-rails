class AddFacadeToClient < ActiveRecord::Migration
  def change
    add_column :bit_pay_rails_clients, :facade, :string
  end
end
