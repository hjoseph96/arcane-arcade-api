class SupportedPlatformListingSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attribute :supported_platform do |object|
    object.supported_platform_id.to_s
  end

  attribute :system_requirements do |object|
    if object.system_requirements
      {
        platform: object.supported_platform.name,
        minimum: object.system_requirements["minimum"],
        recommended: object.system_requirements["recommended"],
        additional_notes: object.system_requirements["additional_notes"],
      }
    end
  end

  belongs_to :distribution, serializer: DistributionSerializer
end
