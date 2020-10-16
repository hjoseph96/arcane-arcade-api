class Distribution < ApplicationRecord
  belongs_to :supported_platform_listing

  has_one :installer, dependent: :destroy

  enum method: { steam_keys: 0, installer: 1 }, _prefix: :method

  accepts_nested_attributes_for :installer

  validates_presence_of :method

  validates :steam_keys, presence: true, if: :method_steam_keys?
  validate :has_minimum_steam_keys, if: :method_steam_keys?, on: :create
  validates :installer, presence: true, if: :method_installer?

  def get_key!
    key = self.steam_keys.shift
    self.save!
    key
  end

  def add_key!(key)
    self.steam_keys.push(key)
    self.save!
  end

  def installer_url
    self.installer&.installer_url
  end

  private

  def has_minimum_steam_keys
    if self.steam_keys.present?
      self.errors.add(:base, 'You must add at least 50 steam keys.') if steam_keys.length < 50
    end
  end
end
