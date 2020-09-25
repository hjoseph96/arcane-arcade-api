class SupportedPlatform < ApplicationRecord
  has_many :supported_platform_listings
  has_many :listings, through: :supported_platform_listings
end
