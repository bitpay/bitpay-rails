class BitPayRailsClient < ActiveRecord::Migration
  def change
    create_table :bit_pay_clients do |t|
      t.string :api_uri
      t.string :pem
      t.string :facade, default: "merchant"

      t.timestamps null: false
    end
  end
end
