class ListingTag < ApplicationRecord
  belongs_to :listing
  belongs_to :tag

  accepts_nested_attributes_for :tag
end
