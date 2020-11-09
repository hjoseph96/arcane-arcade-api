class V1::SessionsController < ApiController
  before_action :authenticate, except: [:create, :send_password_token, :authorize_password_token, :reset_password]

  def create
    password = login_params[:password]
    username_or_email = login_params[:username]
    remember = login_params[:remember_me] ? true : false

    @user = login(username_or_email, password, remember)

    if @user
      token = Jwt::TokenProvider.(user_id: @user.id)
      render_success(data: { user: serialized_user, token: token })
    else
      render_error(message: "Wrong username or password", status: 401)
    end
  end

  def is_logged_in?
    @user = Jwt::UserAuthenticator.(request.headers)
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

  def send_password_token
    @user = User.find_by(email: params[:auth][:email])

    if @user.present?
      @user.generate_reset_password_token!
      UserMailer.with(user: @user).forgot_password.deliver_now
      render_success(data: @user.email)
    else
      error_msg = "No user found with email: #{params[:email]}"
      render_error(message: error_msg, status: :not_found)
    end
  end

  def authorize_password_token
    @user = User.load_from_reset_password_token(params[:auth][:code])
    if @user.present?
      render_success(data: @user.email)
    else
      render_error(message: "No user found with that reset_password_token")
    end
  end

  def reset_password
    @user = User.find_by(email: params[:email])
    if @user.change_password!(params[:password])
      render_success
    else
      render_error(message: "Error while resetting password for '#{@user.email}'")
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
