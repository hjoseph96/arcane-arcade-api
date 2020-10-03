class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def render_success(data: {}, status: :ok)
    render json: data, status: status
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

  private

  def serialized_user
    UserSerializer.new(@user || current_user, include: [:seller]).serializable_hash
  end

  def record_not_found
    render_error(status: :not_found)
  end

  def not_authenticated
    render_error(status: :unauthorized)
  end
end
