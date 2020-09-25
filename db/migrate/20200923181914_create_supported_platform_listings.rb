class CreateSupportedPlatformListings < ActiveRecord::Migration[6.0]
  def change
    create_table :supported_platform_listings do |t|
      t.references :supported_platform, type: :integer, null: false, foreign_key: true
      t.references :listing, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
