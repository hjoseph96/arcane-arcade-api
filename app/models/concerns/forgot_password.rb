module ForgotPassword
  extend ActiveSupport::Concern

  def generate_reset_password_token!
    self.reset_password_token = loop do
      random_token = (SecureRandom.random_number(9e6) + 1e6).to_i
      break random_token unless self.class.exists?(reset_password_token: random_token)
    end
    self.reset_password_email_sent_at = Time.now
    self.save!
  end

  def change_password!(password)
    self.password = password
    self.password_confirmation = password
    self.save!
  end
end
