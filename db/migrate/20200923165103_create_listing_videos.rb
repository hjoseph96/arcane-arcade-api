class CreateListingVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :listing_videos, id: :uuid do |t|
      t.references :listing, type: :uuid, foreign_key: true
      t.string :youtube_id
      t.string :vimeo_id
      t.text :video_data

      t.timestamps
    end
  end
end
