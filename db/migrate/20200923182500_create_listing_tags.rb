class CreateListingTags < ActiveRecord::Migration[6.0]
  def change
    create_table :listing_tags do |t|
      t.references :listing, type: :uuid, null: false, foreign_key: true
      t.references :tag, type: :integer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
