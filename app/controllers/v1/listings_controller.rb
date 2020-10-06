class V1::ListingsController < ApiController
  before_action :require_login, except: :index
  before_action :require_seller, only: [:create, :update]

  def index
    page = params[:page]
    page ||= 1

    @listings = Listing.includes([:listing_videos, :listing_images, :seller])
                  .page(page).per(30)

    render_success(data: serialized_listing)
  end

  def show
    @listing = Listing.friendly.find(params[:id])

    render_success(data: serialized_listing)
  end

  def new
    @supported_platforms = SupportedPlatform.roots
    @categories = Category.all
    @tags = Tag.all

    render_success(data: { supported_platforms: serialized_supported_platforms, categories: serialized_categories, tags: serialized_tags })
  end

  def create
    category_ids = create_params[:category_ids]
    supported_platforms_ids = create_params[:supported_platforms_ids]

    parsed_params = create_params.except(:category_ids, :supported_platforms_ids)

    @listing = current_user.seller.listings.new(parsed_params)

    # TODO: Send this from frontend maybe?
    @listing.release_date = Time.now.utc

    if category_ids.present?
      @listing.categories << Category.find(category_ids)
    end

    if supported_platforms_ids.present?
      @listing.supported_platforms << SupportedPlatform.find(supported_platforms_ids)
    end

    if @listing.save
      render_success(data: serialized_listing)
    else
      render_error(model: @listing)
    end
  end

  def update
    @listing = Listing.friendly.find(params[:id])

    if @listing.seller != current_user.seller
      render_error(message: "Can't perform this action") && return
    end

    if @listing.update(update_params)
      render_success(data: serialized_listing)
    else
      render_error(model: @listing)
    end
  end

  private

  def create_params
    params.require(:listing).permit(
      :title, :description, :price, :early_access, :esrb,
      category_ids: [], supported_platforms_ids: [],
      listing_images_attributes: [image: [:id, :storage, metadata: [:size, :filename, :mime_type]]],
      listing_videos_attributes: [video: [:id, :storage, metadata: [:size, :filename, :mime_type]]],
      listing_attachments_attributes: [attachment: [:id, :storage, metadata: [:size, :filename, :mime_type]]],
      listing_tags_attributes: [:tag_id]
    )
  end

  def serialized_tags
    TagSerializer.new(@tags).serializable_hash
  end

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
