class RemoveDescriptionFromListings < ActiveRecord::Migration[6.0]
  def change
    remove_column :listings, :description
  end
end
