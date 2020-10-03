class Order < ApplicationRecord
  belongs_to :listing
  has_one :seller, through: :listing
  belongs_to :buyer, class_name: 'User', foreign_key: :buyer_id

  enum status: %i(in_progress unconfirmed in_escrow completed)
  enum coin_type: %w(BTC XMR)

  def listing_slug
    listing.slug
  end
end
