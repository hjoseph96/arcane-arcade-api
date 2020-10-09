class ImageUploader < Shrine
  def generate_location(io, record: nil, derivative: nil, **)
    return super unless record.id
    record.image.id
  end
end
