class ListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes  :title, :price, :description, :preorderable,
              :early_access, :esrb, :images, :videos

end
