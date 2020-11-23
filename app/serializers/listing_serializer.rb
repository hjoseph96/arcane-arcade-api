class ListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attribute :description do |object|
    object.description.to_s
  end

  attribute :raw_description do |object|
    object.description.to_plain_text.gsub('[Image]', '')
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

  attribute :category_listings do |object|
    object.category_listings.map do |category_listing|
      {
        id: category_listing.id.to_s,
        category: category_listing.category_id.to_s
      }
    end
  end

  attribute :listing_tags do |object|
    object.listing_tags.map do |listing_tag|
      {
        id: listing_tag.id.to_s,
        tag: listing_tag.tag_id.to_s
      }
    end
  end

  attribute :tags do |object|
    object.tags.pluck(:id).map(&:to_s)
  end

  attribute :saved_files do |object|
    object.listing_images.map{|image| {
      id: image.id,
      url: image.image_url,
      name: image.image.metadata["filename"],
      type: image.image.metadata["mime_type"],
      position: image.position
    }} +
    object.listing_videos.map{|video| {
      id: video.id,
      url: video.video_url,
      name: video.video.metadata["filename"],
      type: video.video.metadata["mime_type"],
      position: video.position
    }}
  end

  attributes    :title, :slug, :preorderable, :release_date,
                :early_access, :esrb, :images, :videos,
                :currency_symbol, :default_currency,
                :btc_amount, :xmr_amount, :accepts_bitcoin, :accepts_monero,
                :status, :featured, :promoted, :supported_languages

  belongs_to :seller, serializer: SellerSerializer
  has_many :supported_platform_listings, serializer: SupportedPlatformListingSerializer
end
