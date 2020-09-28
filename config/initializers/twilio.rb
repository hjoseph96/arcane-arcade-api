account_sid = Rails.application.credentials.TWILIO_SID
auth_token = Rails.application.credentials.TWILIO_AUTH_TOKEN

TWILIO = Twilio::REST::Client.new(
  account_sid, auth_token
)
