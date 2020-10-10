class DistributionSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes :method, :steam_keys

  attribute :installer_url do |object|
    object.installer && object.installer.installer_url
  end
end
