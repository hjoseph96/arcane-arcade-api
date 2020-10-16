class AddUserAndSupportedPlatformListingReferencesToOwnedGames < ActiveRecord::Migration[6.0]
  def change
    add_reference :owned_games, :user, null: false, foreign_key: true
    add_reference :owned_games, :supported_platform_listing, null: false, foreign_key: true
    add_column :owned_games, :status, :integer, null: false, default: 0
  end
end
