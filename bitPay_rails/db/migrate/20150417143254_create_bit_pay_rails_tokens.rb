class CreateBitPayRailsTokens < ActiveRecord::Migration
  def change
    create_table :bit_pay_rails_tokens do |t|
      t.string :token
      t.string :facade
      t.date :date_created
      t.date :pairing_expiration
      t.string :pairing_code
      t.integer :client_id

      t.timestamps null: false
    end
  end
end
