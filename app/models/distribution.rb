class Distribution < ApplicationRecord
  belongs_to :listing

  has_many :installers

  accepts_nested_attributes_for :installers
end
