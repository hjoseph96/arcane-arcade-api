class ListingAttachment < ApplicationRecord
  include ImageUploader::Attachment(:attachment)

  belongs_to :listing
end
