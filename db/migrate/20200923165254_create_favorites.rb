class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites, id: :uuid do |t|
      t.references :listing, type: :uuid, foreign_key: true
      t.references :user, type: :integer, foreign_key: true

      t.timestamps
    end
  end
end
