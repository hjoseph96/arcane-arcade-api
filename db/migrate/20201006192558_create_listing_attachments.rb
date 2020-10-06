class CreateListingAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :listing_attachments, id: :uuid do |t|
      t.references :listing, type: :uuid, null: false, foreign_key: true
      t.text :attachment_data

      t.timestamps
    end
  end
end
