class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :seller
  has_many :owned_games
  has_many :favorites

  accepts_nested_attributes_for :seller
end
