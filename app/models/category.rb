class Category < ApplicationRecord
  has_many :category_listings
  has_many :listings,  through: :category_listings

  validates :title, uniqueness: true

  def ids
    ids = [self.descendants.map(&:id), self.id].flatten
  end
end
