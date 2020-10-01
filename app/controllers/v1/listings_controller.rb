class V1::ListingsController < ApplicationController

  def index
    page = params[:page]
    page ||= 1

    @listings = Listing.includes([:listing_videos, :listing_images, :seller])
                  .page(page).per(30)

    @listings = ListingSerializer.new(@listings)

    render_success(status: :ok, data: @listings)
  end


  def show
    @listing = Listing.find(params[:id])

    if @listing
      render_success(status: ok, data: ListingSerializer.new(@listing))
    else
      render_error(message: 'listing not found', status: :not_found)
    end
  end


end
