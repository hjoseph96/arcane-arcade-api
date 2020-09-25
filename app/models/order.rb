class Order < ApplicationRecord
  belongs_to :listing
  belongs_to :seller, through: :listing
  belongs_to :buyer, model: 'User', foreign_key: :buyer_id

  enum status: %i(in_progress unconfirmed in_escrow completed)
  enum coin_type: %w(BTC XMR)
end
