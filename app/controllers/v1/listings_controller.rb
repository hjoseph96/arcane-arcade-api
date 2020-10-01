class V1::ListingsController < ApplicationController
  def index
    page = params[:page]
    page ||= 1

    @listings = Listing.page(page).per(30)

    render_success(status: :ok, data: serialized_listing)
  end

  def serialized_listing
    ListingSerializer.new(@listings || @listing).serializable_hash[:data]
  end
end
