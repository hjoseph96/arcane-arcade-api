class UserMailer < ApplicationMailer
  def activation_needed_email(user)
  end

  def two_factor_auth
    @user = params[:user]
    mail to: @user.email, subject: "Activation Code"
  end
end
