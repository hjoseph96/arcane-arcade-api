class CreateOwnedGames < ActiveRecord::Migration[6.0]
  def change
    create_table :owned_games, id: :uuid do |t|
      t.references :listing, type: :uuid, foreign_key: true, null: false
      t.references :order, type: :uuid, foreign_key: true, null: false
      t.integer :owner_id, foreign_key: true, null: false

      t.timestamps
    end

    add_index :owned_games, :owner_id
  end
end
