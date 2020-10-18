class AddExpiredWorkerIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :expired_worker_job_id, :string
    add_index :orders, :expired_worker_job_id
  end
end
