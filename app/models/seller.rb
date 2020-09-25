class Seller < ApplicationRecord
  belongs_to :user
  has_many :listings
  has_many :orders

  enum studio_size: %w(INDIE MIDSIZE AAA)
  enum default_currency: %w(USD EUR JPY GBP AUD CAD CHF CNH SEK NZD)
end
