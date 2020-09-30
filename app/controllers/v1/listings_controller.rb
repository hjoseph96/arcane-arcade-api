class V1::ListingsController < ApplicationController
  def index
    page = params[:page] || 1

    @listings = Listing.page(page: page, per: 30)

    render_success(@listings, :ok)
  end
end
