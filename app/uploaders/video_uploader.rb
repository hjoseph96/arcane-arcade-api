class VideoUploader < Shrine
  def generate_location(io, record: nil, derivative: nil, **)
    return super unless record.id
    record.video.id
  end
end
