class RemoveDescriptionFromListings < ActiveRecord::Migration[6.0]
  def up
    remove_column :listings, :description
  end
  def down
    add_column :listings, :description, :text
  end
end
