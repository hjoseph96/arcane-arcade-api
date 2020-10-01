class ListingVideo < ApplicationRecord
  include VideoUploader::Attachment(:video) # adds an `image` virtual attribute

  belongs_to :listing
end
