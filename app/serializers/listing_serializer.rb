class ListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes    :title, :slug, :price, :description, :preorderable,
                :early_access, :esrb, :images, :videos,
                :currency_symbol, :default_currency,
                :btc_amount, :xmr_amount, :accepts_bitcoin, :accepts_monero


  belongs_to :seller, serializer: SellerSerializer
end
