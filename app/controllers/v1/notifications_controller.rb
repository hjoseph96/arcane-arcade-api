class V1::Notifications < ApplicationController
  def create
    @notification = Notification.create(notification_params)

    if @notification.save
      render json: { notification: @notification, status: :created }
    else
      render json: { status: 401, errors: @notification.errors.full_messages }
    end
  end


  def index
    @notifications = Notification.where(user_id: params[:user_id], seen: false)

    unless @notifications.empty?
      render json: { notifications: @notifications, status: :ok }
    else
      render json: {
        status: 404,
        error: "No notifications for User##{params[:user_id]}"
      }
    end
  end


  def mark_as_read
    @notification = Notification.find(params[:id])

    if @notification && @notification.update(seen: true)
      render json: { notification: @notification, status: :accepted }
    else
      render json: {
        errors: @notification.errors.full_messages,
        status: :not_found
      }
    end
  end


  private

  def notification_params
    params.require(:notification).permit(
      :user_id, :seen, :destination_path, :message
    )
  end
end
