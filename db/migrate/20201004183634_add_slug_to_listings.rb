class AddSlugToListings < ActiveRecord::Migration[6.0]
  def up
    add_column :listings, :slug, :string
    add_index :listings, :slug, unique: true

    Listing.find_each(&:save)

    change_column_null :listings, :slug, false
  end

  def down
    remove_index :listings, :slug
    remove_column :listings, :slug
  end
end
