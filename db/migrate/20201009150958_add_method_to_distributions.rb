class AddMethodToDistributions < ActiveRecord::Migration[6.0]
  def change
    add_column :distributions, :method, :integer, null: false, default: 0
  end
end
