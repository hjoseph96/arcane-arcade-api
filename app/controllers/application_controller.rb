class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  skip_before_action :verify_authenticity_token

  def render_success(data: {}, status: :created)
    render json: { status: status, data: data }
  end

  def render_error(model: nil, message: nil, status: :unprocessable_entity)
    if model
      render json: { full_messages: model.errors.full_messages, errors: model.errors }, status: status
    elsif message
      render json: { full_messages: [message] }, status: status
    else
      head status
    end
  end
end
