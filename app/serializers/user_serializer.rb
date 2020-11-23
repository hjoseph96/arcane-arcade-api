class UserSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes :username, :email, :phone_number, :activation_state, :admin

  has_one :seller, serializer: SellerSerializer
end
