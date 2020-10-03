class OrderSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes :listing_slug, :coin_amount, :coin_type, :coin_price_at_time,
              :expires_at, :status, :preordered, :been_reviewed, :fiat_currency,
              :escrow_address


end
