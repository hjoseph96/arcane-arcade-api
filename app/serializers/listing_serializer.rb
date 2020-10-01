class ListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes  :title, :slug, :price, :description, :preorderable,
              :early_access, :esrb, :images, :videos,
              :btc_amount, :xmr_amount, :currency_symbol,
              :default_currency
end
