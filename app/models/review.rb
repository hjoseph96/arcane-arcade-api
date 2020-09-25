class Review < ApplicationRecord
  belongs_to :author, model: 'User', foreign_key: :author_id
  belongs_to :listing
end
