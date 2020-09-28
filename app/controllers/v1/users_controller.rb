class V1::UsersController < ApplicationController

  def create
    @user = User.new(user_params)

    if @user.save!
      activation_token = (SecureRandom.random_number(9e6) + 1e6).to_i
      @user.activation_token = activation_token
      @user.save!

      render json:  { status: :created, user: @user }
    else
      render json: { error: @user.errors.full_messages, status: 500 }
    end
  end


  private

  def user_params
    params.require(:user).permit(
      :username, :password, :password_confirmation, :email, :phone_number
    )
  end
end
