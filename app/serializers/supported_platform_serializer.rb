class SupportedPlatformSerializer
  include FastJsonapi::ObjectSerializer

  attribute :id do |object|
    object.id.to_s
  end

  attributes :name

  attribute :children do |object|
    object.children.map do |children|
      SupportedPlatformSerializer.new(children).serializable_hash[:data][:attributes]
    end
  end
end
