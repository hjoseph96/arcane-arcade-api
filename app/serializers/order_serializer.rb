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
    serialized = {
      title: object.listing.title,
      image: object.listing.images.first,
      platform: object.owned_game.platform,
      method: object.owned_game.method,
    }

    if object.in_escrow?
      serialized[:steam_key] = object.owned_game.steam_key
      serialized[:installer_url] = object.owned_game.installer_url
    end

    serialized
  end
end
