class UserMailer < ApplicationMailer
  def activation_needed_email(user)
  end

  def two_factor_auth
    @user = params[:user]
    mail to: @user.email, subject: "Arcane Arcane: Activation Code"
  end

  def forgot_password
    @user = params[:user]
    mail to: @user.email, subject: 'Action Required – Your “Forgot My Password” Request'
  end
end
