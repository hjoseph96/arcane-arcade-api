class AddAncestryToSupportedPlatforms < ActiveRecord::Migration[6.0]
  def change
    add_column :supported_platforms, :ancestry, :string
    add_index :supported_platforms, :ancestry
  end
end
