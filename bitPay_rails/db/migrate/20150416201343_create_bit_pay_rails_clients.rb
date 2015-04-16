class CreateBitPayRailsClients < ActiveRecord::Migration
  def change
    create_table :bit_pay_rails_clients do |t|
      t.string :encrypted_pem
      t.string :api_uri

      t.timestamps null: false
    end
  end
end
