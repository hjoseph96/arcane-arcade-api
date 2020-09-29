class CreateSellers < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers do |t|
      t.integer :user_id, foreign_key: true, null: false
      t.text :accepted_crypto, array: true, null: false
      t.integer :default_currency, null: false
      t.string :business_name, null: false
      t.integer :studio_size, null: false
      t.boolean :curated, default: false, null: false
      t.text :logo_data
      t.jsonb :destination_addresses

      t.timestamps
    end

    add_index :sellers, :accepted_crypto
    add_index :sellers, :default_currency
    add_index :sellers, :curated
    add_index :sellers, :studio_size
  end
end
