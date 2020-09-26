class Redemption < ApplicationRecord
  belongs_to :owned_game
  has_one :listing, through: :owned_game
  has_one :order, through: :owned_game
  has_one :supported_platform, through: :owned_game


end
