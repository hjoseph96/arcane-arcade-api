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

  belongs_to :seller
  belongs_to :category

  enum esrb: %w(EVERYONE E_TEN_PLUS TEEN MATURE ADULT)
end
