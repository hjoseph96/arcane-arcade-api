class RemoveResetPasswordEmailSentAtFromUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :reset_password_email_sent_at
  end

  def down
    add_column :users, :reset_password_email_sent_at, :datetime, default: nil
  end
end
