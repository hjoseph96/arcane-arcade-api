if Rails.env.development? || Rails.env.test?
  PAYMENT_API = 'http://localhost:8000/api/v1'
elsif Rails.env.production?
  # TODO: Move to Rails.application.credentials
  PAYMENT_API = 'https://payments.arcanearcade.io/api/v1'
end
