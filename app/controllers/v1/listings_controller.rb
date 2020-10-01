class V1::ListingsController < ApplicationController

  def index
    page = params[:page]
    page ||= 1

    @listings = Listing.includes([:listing_videos, :listing_images, :seller])
                  .page(page).per(30)

    render_success(status: :ok, data: serialized_listing)
  end

  def serialized_listing
    ListingSerializer.new(@listings || @listing).serializable_hash[:data]
  end


  def show
    @listing = Listing.friendly.find(params[:id])

    if @listing
      render_success(status: ok, data: ListingSerializer.new(@listing))
    else
      render_error(message: 'listing not found', status: :not_found)
    end
  end


end
