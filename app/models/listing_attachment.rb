class ListingAttachment < ApplicationRecord
  include AttachmentUploader::Attachment(:attachment, store: :store)

  belongs_to :listing

  def update_trix_attachment(old_id)
    trix_body = self.listing.description.body.to_s.dup
    trix_attachment = self.listing.description.body.attachments.find{|a| a.url.include?(old_id) }
    if trix_attachment
      url = URI.extract(trix_body)[0]
      trix_body.gsub!(url, self.attachment_url)
      self.listing.update description: trix_body
    end
  end
end
