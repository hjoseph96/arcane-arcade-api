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
    self.listing_images.map do |image|
      "#{Rails.root}#{image.image.url}"
    end
  end

  def videos
    self.listing_videos.map do |video|
      "#{Rails.root}#{video.video.url}"
    end
  end

end
