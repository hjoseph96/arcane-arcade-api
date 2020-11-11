class V1::Admins::ListingsController < V1::AdminsController
  before_action :set_listing, only: [:update]

  def index
    include_list = %i(
      listing_videos listing_images seller supported_platform_listings
    )

    @listings = Listing.pending.includes(include_list)
    render_success(data: serialized_listing(includes: [:seller, :supported_platform_listings, :'supported_platform_listings.distribution']))
  end

  def update
    if @listing.update(update_params)
      head :ok
    else
      render_error(model: @listing)
    end
  end

  private

  def update_params
    params.fetch(:listing, {}).permit(:status)
  end

  def set_listing
    @listing = Listing.pending.find(params[:id])
  end

  def serialized_listing(includes: )
    ListingSerializer.new(@listings || @listing, include: includes).serializable_hash
  end
end
