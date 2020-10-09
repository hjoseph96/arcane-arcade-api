class Installer < ApplicationRecord
  include InstallerUploader::Attachment(:installer, store: :secure)

  belongs_to :distribution
end
