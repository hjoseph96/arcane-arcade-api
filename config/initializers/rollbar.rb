require 'rollbar'

Rollbar.configure do |config|
  config.access_token = Rails.application.credentials.ROLLBAR_ACCESS_TOKEN
end
