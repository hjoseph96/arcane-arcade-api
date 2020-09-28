class V1::SessionsController < ApplicationController
  def create
    password = login_params[:password]
    username_or_email = login_params[:username]
    remember = login_params[:remember_me] ? true : false

    @user = login(username_or_email, password, remember)
    if @user
      render json: { user: @user, logged_in: true }
    else
      render json: { status: 401, error: @user.errors.full_messages }
    end
  end


  def destroy
    logout

    render json: {
      status: 200,
      logged_out: true
    }
  end


  def is_logged_in?
    if logged_in? && current_user
      render json: {
        logged_in: true,
        user: current_user
      }
    else
      render json: {
        logged_in: false,
        message: 'no such user'
      }
    end
  end


  def send_auth_token
    @user = User.find(params[:user_id])
    @delivery_method = auth_params[:delivery_method]

    case @delivery_method
    when 'email'
      UserMailer.two_factor_auth_email(@user)
      render json: { status: :ok, message: "email sent" }
    when 'sms'
      TWILIO.messages.create(
        from: '+1 347 434 6260',
        to: @user.phone_number,
        body: "#{@user.activation_token} is your code from Arcane Arcade."
      )
      render json: { status: :ok, message: "sms sent" }
    end
  end


  def authorize
    @user = User.find(params[:user_id])
    entered_code = auth_params[:code]

    if (@user.activation_token == entered_code)
      @user.activate! if @user.activation_state != 'active'
      auto_login(@user)

      render json: { status: :ok, message: "user has been validated" }
    else
      render json: { error: 'invalid code', status: :unprocessable_entity }
    end
  end

  private

  def login_params
    params.require(:user).permit(:username, :password, :remember_me)
  end

  def auth_params
    params.require(:auth).permit(:delivery_method, :code)
  end
end
