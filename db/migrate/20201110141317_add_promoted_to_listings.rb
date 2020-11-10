class AddPromotedToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :promoted, :boolean, null: false, default: false
  end
end
