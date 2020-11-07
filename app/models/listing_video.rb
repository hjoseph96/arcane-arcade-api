class ListingVideo < ApplicationRecord
  include VideoUploader::Attachment(:video, store: :store) # adds an `image` virtual attribute

  belongs_to :listing

  validates_presence_of :position
end
