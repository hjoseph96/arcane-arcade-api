class V1::SupportedPlatformListingsController < ApiController
  before_action :authenticate
  before_action :require_seller
  before_action :set_listing
  before_action :set_supported_platform_listing

  def update
    if @supported_platform_listing.update(distribution_params)
      render_success(data: serialized_supported_platform_listing)
    else
      render_error(model: @supported_platform_listing)
    end
  end

  private

  def serialized_supported_platform_listing
    SupportedPlatformListingSerializer.new(@supported_platform_listing, include: [:distribution]).serializable_hash
  end

  def distribution_params
    params.require(:supported_platform_listing).permit(
      distribution_attributes: [
        :_destroy, :method,
        steam_keys: [],
        installer_attributes: [
          installer: [
            :id, :storage,
            metadata: [:size, :filename, :mime_type]
          ]
        ]
      ]
    )
  end

  def set_listing
    @listing = Listing.friendly.find(params[:listing_id])
  end

  def set_supported_platform_listing
    @supported_platform_listing = @listing.supported_platform_listings.find(params[:id])
  end
end

