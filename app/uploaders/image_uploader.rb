class ImageUploader < Shrine
  def generate_location(io, record: nil, derivative: nil, **)
    return super unless record
    record.image.id
  end
end
