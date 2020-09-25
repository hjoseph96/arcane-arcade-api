class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews, id: :uuid do |t|
      t.integer :author_id, foreign_key: true, null: false
      t.references :listing, type: :uuid, foreign_key: true
      t.text :content
      t.decimal :stars

      t.timestamps
    end
    add_index :reviews, :author_id
    add_index :reviews, :stars
  end
end
