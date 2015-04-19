class RemoveTheTokens < ActiveRecord::Migration
  def change
    drop_table :bit_pay_rails_tokens
  end
end
