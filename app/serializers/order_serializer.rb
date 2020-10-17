class OrderSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes :coin_amount, :coin_type, :expires_at,
             :status, :preordered, :been_reviewed, 
             :fiat_currency, :escrow_address, :qr_url,
             :created_at

  attribute :owned_game do |object|
    {
      title: object.listing.title,
      image: object.listing.images.first,
    }
  end
end
