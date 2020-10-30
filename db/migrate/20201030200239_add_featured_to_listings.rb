class AddFeaturedToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :featured, :boolean, null: false, default: false
  end
end
