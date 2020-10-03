class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.references :listing, type: :uuid, foreign_key: true, null: false
      t.integer :buyer_id, foreign_key: true, null: false
      t.decimal :coin_amount
      t.decimal :coin_price_at_time
      t.string :fiat_currency
      t.string :escrow_address
      t.datetime :expires_at
      t.integer :coin_type
      t.integer :status
      t.boolean :preordered, default: false
      t.boolean :been_reviewed, default: false

      t.timestamps
    end

    add_index :orders, :buyer_id
    add_index :orders, :coin_amount
    add_index :orders, :coin_type
    add_index :orders, :status
  end
end
