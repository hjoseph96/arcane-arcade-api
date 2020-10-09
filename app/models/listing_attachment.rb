class ListingAttachment < ApplicationRecord
  include AttachmentUploader::Attachment(:attachment)

  belongs_to :listing

  after_commit :update_trix_attachment, on: [:create, :update]

  private

  def update_trix_attachment
    if self.attachment.storage_key == :store
      trix_body = self.listing.description.body.to_s.dup
      trix_attachment = self.listing.description.body.attachments.find{|a| a.url.include?(self.attachment.id) }
      if trix_attachment
        url = URI.extract(trix_body)[0]
        trix_body.gsub!(url, self.attachment_url)
        self.listing.update description: trix_body
      end
    end
  end
end
