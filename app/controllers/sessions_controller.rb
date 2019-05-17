class SessionsController < ApplicationController
  def new
  end

  def create
      user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = 'login!'
      log_in user
      puts '****chk=' + params[:session][:remember_me]
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
