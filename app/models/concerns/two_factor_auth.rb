module TwoFactorAuth
  extend ActiveSupport::Concern

  TOKEN_EXPIRES_IN = 10.minutes

  def generate_2fa_token!
    self.activation_token = loop do
      random_token = (SecureRandom.random_number(9e6) + 1e6).to_i
      break random_token unless self.class.exists?(activation_token: random_token)
    end
    self.activation_state = "pending"
    self.activation_token_expires_at = Time.now.utc + TOKEN_EXPIRES_IN
    self.save!
  end
end
