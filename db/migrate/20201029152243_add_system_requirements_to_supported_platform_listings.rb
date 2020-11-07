class AddSystemRequirementsToSupportedPlatformListings < ActiveRecord::Migration[6.0]
  def change
    add_column :supported_platform_listings, :system_requirements, :jsonb
  end
end
