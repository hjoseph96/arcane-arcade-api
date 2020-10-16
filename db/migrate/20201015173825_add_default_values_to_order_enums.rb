class AddDefaultValuesToOrderEnums < ActiveRecord::Migration[6.0]
  def change
    change_column_default :orders, :status, from: nil, to: 0
    change_column_default :orders, :coin_type, from: nil, to: 0
  end
end
