class AddPositionToFiles < ActiveRecord::Migration[6.0]
  def up
    add_column :listing_images, :position, :integer, null: false, default: 0
    add_column :listing_videos, :position, :integer, null: false, default: 0

    Listing.find_each do |listing|
      files = listing.listing_images + listing.listing_videos
      files.each_with_index do |file, index|
        file.update position: index
      end
    end
  end

  def down
    remove_column :listing_images, :position
    remove_column :listing_videos, :position
  end
end
