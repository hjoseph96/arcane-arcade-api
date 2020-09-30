module TwoFactorAuth
  extend ActiveSupport::Concern

  included do
    before_create :generate_2fa_token!
  end

  def generate_2fa_token!
    activation_token = (SecureRandom.random_number(9e6) + 1e6).to_i
    self.activation_token = activation_token
  end
end
