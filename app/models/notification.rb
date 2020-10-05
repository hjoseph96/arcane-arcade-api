class Notification < ApplicationRecord
  belongs_to :user

  scope :not_seen, -> { where(seen: false) }

  validates_presence_of :destination_path, :message
end
