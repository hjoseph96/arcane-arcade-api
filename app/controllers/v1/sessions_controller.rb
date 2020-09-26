class V1::SessionsController < ApplicationController
  def create
    @user = User.find_by(username: login_params[:username])

    password = login_params[:password]
    username_or_email = login_params[:username]
    remember = login_params[:remember_me] ? ture : false

    if login(username_or_email, password, remember)
      render json: @user.to_json
    else
      render json: { error: @user.errors, status: 422 }
    end
  end

  private

  def login_params
    params.require(:user).permit(:username, :password, :remember_me)
  end
end
