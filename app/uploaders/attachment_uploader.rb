class AttachmentUploader < Shrine
  def generate_location(io, record: nil, derivative: nil, **)
    return super unless record.id
    record.attachment.id
  end
end
