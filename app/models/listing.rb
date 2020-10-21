class Listing < ApplicationRecord
  extend FriendlyId

  friendly_id :title, use: :slugged

  searchkick case_sensitive: false, text_middle: [:title]

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
      price:          self.regular_price,
      tags:           self.tags.map(&:title).join(' '),
      preorderable:   self.preorderable,
      early_access:   self.early_access,
      release_date:   self.release_date,
      reviews_count:  self.reviews.count,
      seller_name:    self.seller.business_name,
      categories:     self.categories.map(&:id),
      description:    self.description.body.to_rendered_html_with_layout,
      supported_platforms: self.supported_platforms.map(&:name).join(', '),
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

  def display_price
    self.price.to_f / 100
  end

  def btc_amount
    CryptoConversion.to_bitcoin(self.regular_price, self.seller.default_currency)
  end

  def xmr_amount
    CryptoConversion.to_monero(self.regular_price, self.seller.default_currency)
  end

  def regular_price   # Price is stored in cents
    self.price / 100
  end

  def default_currency
    seller.default_currency
  end

  def accepts_bitcoin
    return false unless seller.destination_addresses.present?
    seller.accepted_crypto.include?('BTC') && seller.destination_addresses['BTC'].present?
  end

  def accepts_monero
    return false unless seller.destination_addresses.present?
    seller.accepted_crypto.include?('XMR')  && seller.destination_addresses['XMR'].present?
  end
end
