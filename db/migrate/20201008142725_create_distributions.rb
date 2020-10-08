class CreateDistributions < ActiveRecord::Migration[6.0]
  def change
    create_table :distributions, id: :uuid do |t|
      t.references :listing, null: false, foreign_key: true, type: :uuid
      t.text :steam_keys, array: true

      t.timestamps
    end
  end
end
