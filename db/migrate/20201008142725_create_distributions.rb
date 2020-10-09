class CreateDistributions < ActiveRecord::Migration[6.0]
  def change
    create_table :distributions do |t|
      t.references :supported_platform_listing, null: false, foreign_key: true
      t.text :steam_keys, array: true

      t.timestamps
    end
  end
end
