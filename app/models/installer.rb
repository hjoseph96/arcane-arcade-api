class Installer < ApplicationRecord
  include InstallerUploader::Attachment(:installer, store: :secure, cache: :secure_cache)

  belongs_to :distribution
end
