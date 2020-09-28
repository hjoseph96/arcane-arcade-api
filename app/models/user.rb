class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :seller
  has_many :owned_games
  has_many :favorites

  accepts_nested_attributes_for :seller
  
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

end
