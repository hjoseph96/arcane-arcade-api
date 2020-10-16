class OwnedGame < ApplicationRecord
  belongs_to :user
  belongs_to :order
  belongs_to :supported_platform_listing

  has_one :distribution, through: :supported_platform_listing
  has_one :listing, through: :order
  has_one :redemption, dependent: :destroy

  delegate :method_steam_keys?, to: :distribution

  enum status: { pending: 0, active: 1 }

  accepts_nested_attributes_for :redemption, update_only: true

  validates_presence_of :redemption, if: :method_steam_keys?

  before_validation :set_redemption, if: :method_steam_keys?

  def steam_key
    return nil unless self.method_steam_keys?
    self.redemption.code
  end

  def installer_url
    return nil if self.method_steam_keys?
    self.distribution.installer_url
  end

  private

  def set_redemption
    self.build_redemption
  end
end
