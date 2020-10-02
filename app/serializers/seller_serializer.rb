class SellerSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes :accepted_crypto, :business_name, :default_currency, :studio_size
end
