class RemoveListingIdFromOwnedGames < ActiveRecord::Migration[6.0]
  def up
    remove_column :owned_games, :owner_id
    remove_reference :owned_games, :listing, index: true, foreign_key: true
    remove_reference :owned_games, :supported_platform, index: true
  end

  def down
    add_column :owned_games, :owner_id, :integer, null: false
    add_reference :owned_games, :listing, index: true, foreign_key: true, type: :uuid, null: false
    add_reference :owned_games, :supported_platform, index: true, foreign_key: true, type: :uuid, null: false
  end
end
