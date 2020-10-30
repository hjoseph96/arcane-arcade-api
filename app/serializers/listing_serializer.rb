class ListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attribute :description do |object|
    object.description.to_s
  end

  attribute :raw_description do |object|
    object.description.to_plain_text
  end

  attribute :supported_platforms do |object|
    object.supported_platform_ids.map &:to_s
  end

  attribute :price do |object|
    object.display_price
  end

  attribute :categories do |object|
    object.categories.pluck(:id).map(&:to_s)
  end

  attribute :tags do |object|
    object.tags.pluck(:id).map(&:to_s)
  end

  attribute :saved_files do |object|
    object.listing_images.map{|image| { id: image.id, url: image.image_url, type: image.image.metadata["mime_type"] }} +
    object.listing_videos.map{|video| { id: video.id, url: video.video_url, type: video.video.metadata["mime_type"] }}
  end

  attributes    :title, :slug, :preorderable, :release_date,
                :early_access, :esrb, :images, :videos,
                :currency_symbol, :default_currency,
                :btc_amount, :xmr_amount, :accepts_bitcoin, :accepts_monero,
                :status, :featured, :supported_languages

  belongs_to :seller, serializer: SellerSerializer
  has_many :supported_platform_listings, serializer: SupportedPlatformListingSerializer
end
