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
  validate :category_listings_valid?
  validate :supported_platform_listings_valid?
  validate :supported_languages_valid?
  validate :images_and_videos_valid?

  enum esrb: %w(EVERYONE E_TEN_PLUS TEEN MATURE ADULT)
  enum status: %i(pending active rejected)

  scope :featured, -> { where(featured: true) }
  scope :promoted, -> { where(promoted: true) }

  accepts_nested_attributes_for :category_listings, allow_destroy: true
  accepts_nested_attributes_for :listing_tags, allow_destroy: true
  accepts_nested_attributes_for :supported_platform_listings, allow_destroy: true
  accepts_nested_attributes_for :listing_images, :listing_videos, :listing_attachments, allow_destroy: true

  after_update_commit :remove_deleted_attachments

  def search_data
    {
      title:               self.title,
      price:               self.regular_price,
      tags:                self.tags.map(&:title),
      preorderable:        self.preorderable,
      early_access:        self.early_access,
      release_date:        self.release_date,
      reviews_count:       self.reviews.count,
      seller_name:         self.seller.business_name,
      categories:          self.categories.map(&:title),
      description:         self.description.body.to_plain_text.gsub('[Image]', ''),
      supported_platforms: self.supported_platforms.map(&:name),
      featured:            self.featured,
      promoted:            self.promoted
    }
  end

  def images
    images_by_position = self.listing_images.sort_by(&:position)
    images_by_position.map {|image| image.image.url }
  end

  def videos
    videos_by_position = self.listing_videos.sort_by(&:position)
    videos_by_position.map {|video| video.video.url }
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
    if Rails.env.development?
      return 0
    end
    CryptoConversion.to_bitcoin(self.regular_price, self.seller.default_currency)
  end

  def xmr_amount
    if Rails.env.development?
      return 0
    end
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

  private

  def category_listings_valid?
    if self.category_listings.empty?
      self.errors.add(:base, 'Please select at least one category.')
    end
  end

  def supported_platform_listings_valid?
    # reject PC platform
    platform_listings = self.supported_platform_listings.reject{|platform_listing| platform_listing.supported_platform.name == "PC" }
    if platform_listings.empty?
      self.errors.add(:base, 'Please select at least one supported platform.')
    end
  end

  def images_and_videos_valid?
    if self.listing_images.length.zero? && self.listing_videos.length.zero?
      self.errors.add(:base, "Please add at least one image or video.")
      return
    end
  end

  def supported_languages_valid?
    unless self.supported_languages.present?
      self.errors.add(:base, "Please add at least one language in Audio and Text supported languages.")
      return
    end

    self.supported_languages["audio"].reject!{|language| language["name"].blank? }
    audio_languages = self.supported_languages["audio"]
    self.supported_languages["text"].reject!{|language| language["name"].blank? }
    text_languages = self.supported_languages["text"]

    if audio_languages.empty? || text_languages.empty?
      self.errors.add(:base, "Please add at least one language in Audio and Text supported languages")
    end
  end

  def remove_deleted_attachments
    if self.description.saved_change_to_body
      self.listing_attachments.each do |attachment|
        found = self.description.body.attachments.find{|a| a.url == attachment.attachment_url }
        attachment.destroy if !found
      end
    end
  end
end
