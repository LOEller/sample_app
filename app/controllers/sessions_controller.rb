class SessionsController < ApplicationController

  def new
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # equivalent to:
    # if @user && @user.authenticate(params[:session][:password])
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = "Account not activated, check your email for the activation link. "
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

end
