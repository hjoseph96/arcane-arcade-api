class SupportedPlatformListing < ApplicationRecord
  belongs_to :listing
  belongs_to :supported_platform
  has_one :distribution

  accepts_nested_attributes_for :distribution, update_only: true
end
