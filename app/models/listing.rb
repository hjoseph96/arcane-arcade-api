class Listing < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  # searchkick word_middle: [:title]

  has_rich_text :description

  has_many :owned_games
  has_many :listing_images, dependent: :destroy
  has_many :listing_videos, dependent: :destroy
  has_many :listing_attachments, dependent: :destroy
  has_many :favorites
  has_many :reviews

  has_many :orders
  has_many :buyers, through: :orders, foreign_key: :buyer_id

  has_many :listing_tags, dependent: :destroy
  has_many :tags, through: :listing_tags

  has_many :supported_platform_listings, dependent: :destroy
  has_many :supported_platforms, through: :supported_platform_listings
  has_many :distributions, through: :supported_platform_listings

  has_many :category_listings, dependent: :destroy
  has_many :categories, through: :category_listings

  belongs_to :seller

  validates_presence_of :title, :description, :esrb, :price
  validates :title, uniqueness: true
  validates :categories, presence: true

  enum esrb: %w(EVERYONE E_TEN_PLUS TEEN MATURE ADULT)
  enum status: %i(pending active)

  accepts_nested_attributes_for :category_listings
  accepts_nested_attributes_for :supported_platform_listings
  accepts_nested_attributes_for :listing_images, :listing_videos, :listing_tags, :listing_attachments

  def search_data
    {
      title:          self.title,
      price:          self.price / 100,
      description:    self.description,
      tages:          self.tags.map(&:title),
      preorderable:   self.preorderable,
      early_access:   self.early_access,
      release_date:   self.release_date,
      reviews_count:  self.reviews.count,
      seller_name:    self.seller.business_name,
      categories:     self.categories.map(&:title),
      supported_platforms: self.supported_platforms.map(&:name),
    }
  end

  def images
    self.listing_images.map {|image| image.image.url }
  end

  def videos
    self.listing_videos.map {|video| video.video.url }
  end

  def attachments
    self.listing_attachments.map {|attachment| attachment.attachment.url }
  end

  def currency_symbol
     Money.new(self.price, default_currency).symbol
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

  def accepts_bitcoin
    seller.accepted_crypto.include? 'BTC'
  end

  def accepts_monero
    seller.accepted_crypto.include? 'XMR'
  end
end
