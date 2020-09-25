class CreateRedemptions < ActiveRecord::Migration[6.0]
  def change
    create_table :redemptions, id: :uuid do |t|
      t.string :code
      t.references :owned_game, type: :uuid, foreign_key: true, null: false
      t.integer :platform
      t.text :installer_data
      t.integer :method

      t.timestamps
    end
  end
end
