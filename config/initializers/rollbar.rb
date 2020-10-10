require 'rollbar'

Rollbar.configure do |config|
  config.enabled = !Rails.env.development? && !Rails.env.test?
  config.access_token = Rails.application.credentials.ROLLBAR_ACCESS_TOKEN
end
