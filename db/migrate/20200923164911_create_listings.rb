class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings, id: :uuid do |t|
      t.string :title, null: false
      t.decimal :price, null: false
      t.text :description, null: false
      t.references :seller, type: :integer, foreign_key: true, null: false
      t.datetime :release_date, null: false
      t.boolean :preorderable, default: false
      t.boolean :early_access, default: false
      t.integer :hits, default: 0
      t.integer :status
      t.integer :esrb

      t.timestamps
    end
    add_index :listings, :title
    add_index :listings, :price
    add_index :listings, :release_date
    add_index :listings, :preorderable
    add_index :listings, :early_access
    add_index :listings, :hits
    add_index :listings, :status
    add_index :listings, :esrb
  end
end
