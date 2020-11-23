class V1::AdminsController < ApiController
  before_action :authenticate
  before_action :require_admin!

  private

  def require_admin!
    not_authorized unless current_user.admin?
  end
end
