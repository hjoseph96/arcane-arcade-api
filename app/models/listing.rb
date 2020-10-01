class Listing < ApplicationRecord
  has_many :owned_games
  has_many :listing_images
  has_many :listing_videos
  has_many :favorites
  has_many :reviews

  has_many :orders
  has_many :buyers, through: :orders, foreign_key: :buyer_id

  has_many :listing_tags
  has_many :tags, through: :listing_tags

  has_many :supported_platform_listings
  has_many :supported_platforms, through: :supported_platform_listings

  has_many :category_listings
  has_many :categories, through: :category_listings

  belongs_to :seller

  validates :categories, presence: true

  enum esrb: %w(EVERYONE E_TEN_PLUS TEEN MATURE ADULT)
  enum status: %i(pending active)

  def images
    self.listing_images.map {|image| image.image.url }
  end

  def videos
    self.listing_videos.map {|video| video.video.url }
  end

  def currency
    price = Money.new(self.price, default_currency)

    { symbol: price.symbol, fiat: default_currency }
  end

  def btc_amount
    regular_price = self.price / 100
    CryptoConversion.to_bitcoin(regular_price, seller: seller)
  end

  def xmr_amount
    regular_price = self.price / 100
    CryptoConversion.to_monero(regular_price, seller: seller)
  end

  def regular_price   # Price is stored in cents
    regular_price = self.price / 100
  end

  def default_currency
    seller.default_currency
  end
end
