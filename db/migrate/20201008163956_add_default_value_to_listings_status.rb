class AddDefaultValueToListingsStatus < ActiveRecord::Migration[6.0]
  def up
    change_column_default :listings, :status, from: nil, to: 0
    Listing.find_each do |listing|
      listing.update status: 0
    end
    change_column_null :listings, :status, false
  end

  def down
    change_column_null :listings, :status, true
    change_column_default :listings, :status, from: 0, to: nil
  end
end
