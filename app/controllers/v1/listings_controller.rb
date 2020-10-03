class V1::ListingsController < ApplicationController

  def index
    page = params[:page]
    page ||= 1

    @listings = Listing.includes([:listing_videos, :listing_images, :seller])
                  .page(page).per(30)

    render_success(data: serialized_listing)
  end

  def show
    @listing = Listing.friendly.find(params[:id])

    if @listing
      render_success(data: serialized_listing)
    else
      render_error(message: 'listing not found', status: :not_found)
    end
  end

  def new
    @supported_platforms = SupportedPlatform.roots
    @categories = Category.all

    render_success(data: { supported_platforms: serialized_supported_platforms, categories: serialized_categories })
  end

  def create
  end

  private

  def serialized_supported_platforms
    SupportedPlatformSerializer.new(@supported_platforms).serializable_hash
  end

  def serialized_categories
    CategorySerializer.new(@categories).serializable_hash
  end

  def serialized_listing
    ListingSerializer.new(@listings || @listing, include: [:seller]).serializable_hash
  end

end
