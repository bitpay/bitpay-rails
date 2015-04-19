class CreateBitPayRailsClients < ActiveRecord::Migration
  def change
    create_table :bit_pay_rails_clients do |t|
      t.string :pem
      t.string :api_uri
      t.string :facade, default: "merchant"

      t.timestamps null: false
    end
  end
end
