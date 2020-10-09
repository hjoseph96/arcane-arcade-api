class SupportedPlatformListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attribute :supported_platform do |object|
    object.supported_platform_id.to_s
  end

  belongs_to :distribution, serializer: DistributionSerializer
end
