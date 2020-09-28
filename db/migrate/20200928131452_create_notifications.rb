class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.boolean :seen
      t.string :destination_path
      t.references :user, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
    add_index :notifications, :seen
  end
end
