class ShrineCreateDerivativesWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'shrine'

  def perform(listing_id)
    listing = Listing.find(listing_id)
    return unless listing

    listing.listing_images.each do |listing_image|
      listing_image.image_derivatives!
      listing_image.save!
    end

    listing.listing_videos.each do |listing_video|
      listing_video.video_derivatives!
      listing_video.save!
    end
  end
end
