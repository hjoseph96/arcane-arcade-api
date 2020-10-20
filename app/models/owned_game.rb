class OwnedGame < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :supported_platform_listing

  has_one :distribution, through: :supported_platform_listing
  has_one :supported_platform, through: :supported_platform_listing
  has_one :listing, through: :order
  has_one :redemption, dependent: :destroy

  enum status: { pending: 0, active: 1 }

  accepts_nested_attributes_for :redemption, update_only: true

  validates_presence_of :redemption, if: :method_steam_keys?

  before_validation :set_redemption, if: :method_steam_keys?

  def steam_key
    return nil unless self.method_steam_keys?
    self.redemption.code
  end

  def installer_urls
    return nil if self.method_steam_keys?
    # self.distribution.installer_url
    self.listing.supported_platform_listings.includes(:supported_platform).where(supported_platforms: { ancestry: SupportedPlatform.find_by(name: "PC") }).map do |platform|
      {
        name: platform.supported_platform.name,
        url: platform.distribution.installer_url
      }
    end
  end

  def platform
    self.supported_platform.name
  end

  def method
    self.distribution&.method
  end

  def method_steam_keys?
    self.distribution&.method_steam_keys?
  end

  private

  def set_redemption
    self.build_redemption unless self.redemption
  end
end
