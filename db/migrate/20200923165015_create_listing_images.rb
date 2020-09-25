class CreateListingImages < ActiveRecord::Migration[6.0]
  def change
    create_table :listing_images, id: :uuid do |t|
      t.references :listing, type: :uuid, foreign_key: true
      t.text :image_data

      t.timestamps
    end
  end
end
