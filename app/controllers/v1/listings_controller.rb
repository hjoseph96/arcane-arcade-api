class V1::ListingsController < ApiController
  include Search

  before_action :authenticate, except: %i(index show new)
  before_action :require_seller, only: [:create, :update, :seller_listings, :add_distributions]
  before_action :set_listing, only: [:show, :update, :add_distributions]

  def index
    include_list = %i(
      listing_videos listing_images seller supported_platform_listings
    )

    @listings = Listing.includes(include_list).search(search_query, search_options).results

    render_success(data: serialized_listing(includes: [:seller, :supported_platform_listings, :'supported_platform_listings.distribution']))
  end

  def seller_listings
    @listings = current_user.seller.listings.includes(supported_platform_listings: :distribution)
    render_success data: serialized_listing(includes: [:supported_platform_listings, :"supported_platform_listings.distribution"])
  end

  def show
    render_success(data: serialized_listing(includes: [:seller, :supported_platform_listings, :"supported_platform_listings.distribution"]))
  end

  def new
    @supported_platforms = SupportedPlatform.roots
    @categories = Category.all
    @tags = Tag.all

    render_success(data: {
      supported_platforms: serialized_supported_platforms,
      categories: serialized_categories,
      tags: serialized_tags
    })
  end

  def create
    @listing = current_user.seller.listings.new(listing_params)

    if @listing.save
      render_success data: serialized_listing(includes: [:supported_platform_listings, :"supported_platform_listings.distribution"])
    else
      render_error(model: @listing)
    end
  end

  def update
    if @listing.seller != current_user.seller
      render_error(message: "Can't perform this action") && return
    end

    if @listing.update(listing_params)
      render_success data: serialized_listing(includes: [:supported_platform_listings, :"supported_platform_listings.distribution"])
    else
      render_error(model: @listing)
    end
  end

  def add_distributions
    if @listing.seller != current_user.seller
      render_error(message: "Can't perform this action") && return
    end

    if @listing.update(distribution_params)
      @listing.active!
      @supported_platform_listings = @listing.supported_platform_listings.includes(:distribution)
      render_success(data: serialized_supported_platform_listings)
    else
      render_error(model: @listing)
    end
  end

  private

  def set_listing
    @listing = Listing.friendly.find(params[:id])
  end

  def distribution_params
    params.require(:listing).permit(
      supported_platform_listings_attributes: [
        :id,
        distribution_attributes: [
          :method,
          installer_attributes: [
            installer: [
              :id, :storage,
              metadata: [
                :size, :filename, :mime_type
              ]
            ]
          ]
        ]
      ]
    )
  end

  def listing_params
    system_requirements_params = [:os, :processor, :memory, :graphics, :storage, :directX]
    params.require(:listing).permit(
      :title, :description, :price, :early_access, :esrb, :release_date, :preorderable,
      listing_images_attributes: [:id, :position, :_destroy, image: [:id, :storage, metadata: [:size, :filename, :mime_type]]],
      listing_videos_attributes: [:id, :position, :_destroy, video: [:id, :storage, metadata: [:size, :filename, :mime_type]]],
      listing_attachments_attributes: [:id, :_destroy, attachment: [:id, :storage, metadata: [:size, :filename, :mime_type]]],
      listing_tags_attributes: [:id, :_destroy, :tag_id],
      category_listings_attributes: [:id, :_destroy, :category_id],
      supported_languages: [audio: [:name], text: [:name]],
      supported_platform_listings_attributes: [:id, :_destroy, :supported_platform_id, system_requirements: [:additional_notes, minimum: system_requirements_params, recommended: system_requirements_params]]
    )
  end

  def serialized_tags
    TagSerializer.new(@tags).serializable_hash
  end

  def serialized_supported_platforms
    SupportedPlatformSerializer.new(@supported_platforms).serializable_hash
  end

  def serialized_supported_platform_listings
    SupportedPlatformListingSerializer.new(@supported_platform_listings, include: [:distribution]).serializable_hash
  end

  def serialized_categories
    CategorySerializer.new(@categories).serializable_hash
  end

  def serialized_listing(includes: [:seller])
    ListingSerializer.new(@listings || @listing, include: includes).serializable_hash
  end

end
