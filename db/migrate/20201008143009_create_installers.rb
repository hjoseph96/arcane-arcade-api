class CreateInstallers < ActiveRecord::Migration[6.0]
  def change
    create_table :installers, id: :uuid do |t|
      t.references :distribution, null: false, foreign_key: true, type: :uuid
      t.references :supported_platform_listing, null: false, foreign_key: true
      t.text :installer_data, null: false

      t.timestamps
    end
  end
end
