class OwnedGame < ApplicationRecord
  belongs_to :user
  belongs_to :order
  has_one :listing, through: :order
end
