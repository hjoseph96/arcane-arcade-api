class Notification < ApplicationRecord
  belongs_to :user

  scope :not_seen, -> { where(seen: false) }
end
