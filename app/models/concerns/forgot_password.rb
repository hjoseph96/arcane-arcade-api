module ForgotPassword
  extend ActiveSupport::Concern

  EXPIRES_IN = 30.minutes

  def generate_reset_password_token!
    self.reset_password_token = loop do
      random_token = (SecureRandom.random_number(9e6) + 1e6).to_i
      break random_token unless self.class.exists?(reset_password_token: random_token)
    end
    self.reset_password_token_expires_at = Time.now.utc + EXPIRES_IN
    self.access_count_to_reset_password_page += 1
    self.save!
  end

  def change_password!(password)
    self.password = password
    self.password_confirmation = password
    self.save!
  end
end
