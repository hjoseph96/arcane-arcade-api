class V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render_success(data: @user)
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
