class User < ApplicationRecord
  authenticates_with_sorcery!

  include TwoFactorAuth

  has_one :seller
  has_many :owned_games
  has_many :favorites
  has_many :notifications
  has_many :orders, foreign_key: :buyer_id

  accepts_nested_attributes_for :seller

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :phone_number, presence: true
end
