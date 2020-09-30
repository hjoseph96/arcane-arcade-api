class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  skip_before_action :verify_authenticity_token

  def render_success(data: {}, status: :created)
    render json: { status: status, data: data }
  end

  def render_error(model: nil, message: nil, status: :unprocessable_entity)
    if model
      render json: { error: model.errors.full_messages }, status: status
    elsif message
      render json: { error: message }, status: status
    else
      head status
    end
  end
end
