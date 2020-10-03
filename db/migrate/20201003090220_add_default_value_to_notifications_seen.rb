class AddDefaultValueToNotificationsSeen < ActiveRecord::Migration[6.0]
  def change
    change_column_default :notifications, :seen, from: nil, to: false
    change_column_null :notifications, :seen, false
  end
end
