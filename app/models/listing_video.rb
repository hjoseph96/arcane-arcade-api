class ListingVideo < ApplicationRecord
  include VideoUploader::Attachment(:video, store: :store) # adds an `image` virtual attribute

  belongs_to :listing
end
