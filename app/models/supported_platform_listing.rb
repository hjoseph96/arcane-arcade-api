class SupportedPlatformListing < ApplicationRecord
  belongs_to :listing
  belongs_to :supported_platform
end
