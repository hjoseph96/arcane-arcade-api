class Distribution < ApplicationRecord
  belongs_to :supported_platform_listing

  has_one :installer, dependent: :destroy

  enum method: { steam_keys: 0, installer: 1 }, _prefix: :method

  accepts_nested_attributes_for :installer

  validates_presence_of :method

  validates :steam_keys, presence: true, if: :method_steam_keys?
  validate :has_minimum_steam_keys, if: :method_steam_keys?
  validates :installer, presence: true, if: :method_installer?

  private

  def has_minimum_steam_keys
    if self.steam_keys.present?
      self.errors.add(:base, 'You must add at least 50 steam keys.') if steam_keys.length < 50
    end
  end
end
