class V1::UsersController < ApiController
  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      render_success(data: serialized_user, status: :created)
    else
      render_error(model: @user)
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username, :password, :password_confirmation, :email, :phone_number
    )
  end
end
