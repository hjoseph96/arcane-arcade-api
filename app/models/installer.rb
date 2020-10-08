class Installer < ApplicationRecord
  include InstallerUploader::Attachment(:installer)

  belongs_to :distribution
  belongs_to :supported_platform_listing
end
