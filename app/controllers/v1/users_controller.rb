class V1::UsersController < ApplicationController

  def create
    @user = User.new(user_params)

    if @user.save!
      render json:  @user.to_json(include: :seller)
    else
      render json: { error: @user.errors, status: 422 }
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username, :password, :email, :phone_number,
      seller_attributes: [
        :studio_size, :business_name, :default_currency, accepted_crypto: []
      ]
    )
  end
end
