class CleanUpRedemptions < ActiveRecord::Migration[6.0]
  def change
    remove_column :redemptions, :installer_data
    remove_column :redemptions, :method
    remove_column :redemptions, :platform
    change_column_null :redemptions, :code, false
  end
end
