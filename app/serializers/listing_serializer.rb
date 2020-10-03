class ListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  # there is no :slug field added to DB yet
  attributes  :title, :price, :description, :preorderable,
              :early_access, :esrb, :images, :videos,
              :btc_amount, :xmr_amount, :currency_symbol,
              :default_currency

  belongs_to :seller, serializer: SellerSerializer
end
