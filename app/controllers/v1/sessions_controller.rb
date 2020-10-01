class V1::SessionsController < ApplicationController
  before_action :require_login, except: :create

  def create
    password = login_params[:password]
    username_or_email = login_params[:username]
    remember = login_params[:remember_me] ? true : false

    @user = login(username_or_email, password, remember)

    if @user
      render_success(data: serialized_user)
    else
      render_error(message: "Wrong username or password", status: 401)
    end
  end

  def destroy
    reset_sorcery_session

    render_success
  end

  def is_logged_in?
    render_success(data: serialized_user)
  end

  def send_auth_token
    case auth_params[:delivery_method]
    when 'email'
      current_user.generate_2fa_token!
      UserMailer.with(user: current_user).two_factor_auth.deliver_now
      render_success
    when 'sms'
      current_user.generate_2fa_token!
      TWILIO.messages.create(
        from: '+1 347 434 6260',
        to: current_user.phone_number,
        body: "#{current_user.activation_token} is your code from Arcane Arcade."
      )
      render_success
    else
      render_error(message: 'Delivery method not supported', status: :bad_request)
    end
  end


  def authorize
    if current_user.activation_token == auth_params[:code]
      if current_user.activation_token_expires_at > Time.now.utc
        current_user.activate!
        render_success
      else
        render_error(message: "Your token expired. Please request a new one.")
      end
    else
      render_error(message: "Invalid code")
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
