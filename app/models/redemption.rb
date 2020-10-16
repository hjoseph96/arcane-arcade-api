class Redemption < ApplicationRecord
  belongs_to :owned_game
  has_one :listing, through: :owned_game
  has_one :order, through: :owned_game
  has_one :supported_platform_listing, through: :owned_game
  has_one :distribution, through: :supported_platform_listing

  before_create :get_code
  after_destroy :release_code

  private

  def get_code
    self.code = self.distribution.get_key!
    unless self.code
      self.errors.add(:code, :blank)
      throw :abort
    end
  end

  def release_code
    self.distribution.add_key!(self.code)
  end

end
