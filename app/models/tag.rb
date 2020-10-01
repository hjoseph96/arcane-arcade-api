class Tag < ApplicationRecord
  has_many :listing_tags
  has_many :listings, through: :listing_tags

  validates :title, unique: true
end
