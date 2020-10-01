class CreateCategoryListings < ActiveRecord::Migration[6.0]
  def change
    create_table :category_listings do |t|
      t.references :listing, type: :uuid, null: false, foreign_key: true
      t.references :category, type: :integer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
