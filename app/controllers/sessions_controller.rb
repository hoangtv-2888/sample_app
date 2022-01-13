class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate params[:session][:password]
      if user.activated?
        login_remember user
      else
        flash[:warning] = t "acount_not_activated"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
