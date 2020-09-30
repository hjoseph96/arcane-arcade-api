class V1::ListingsController < ApplicationController
  def index
    page = params[:page]
    page ||= 1

    @listings = Listing.page(page).per(30)

    @listings = ListingSerializer.new(@listings)

    render_success(status: :ok, data: @listings)
  end
end
