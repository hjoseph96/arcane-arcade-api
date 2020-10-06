class V1::NotificationsController < ApiController
  before_action :authenticate

  def create
    @notification = current_user.notifications.create(notification_params)

    if @notification.save
      render_success(data: serialized_notifications, status: :created)
    else
      render_error(model: @notification)
    end
  end

  def index
    @notifications = current_user.notifications.not_seen

    render_success(data: serialized_notifications)
  end

  def mark_as_read
    @notification = current_user.notifications.not_seen.find(params[:id])

    if @notification.update(seen: true)
      render_success
    else
      render_error(model: @notification)
    end
  end


  private

  def serialized_notifications
    NotificationSerializer.new(@notifications || @notification).serializable_hash
  end


  def notification_params
    params.require(:notification).permit(
      :seen, :destination_path, :message
    )
  end
end
