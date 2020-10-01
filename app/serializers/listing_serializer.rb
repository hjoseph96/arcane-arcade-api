class ListingSerializer
  include FastJsonapi::ObjectSerializer

  attributes  :id, :title, :price, :description, :preorderable,
              :early_access, :esrb, :images, :videos,
              :currency, :btc_amount, :xmr_amount
end
