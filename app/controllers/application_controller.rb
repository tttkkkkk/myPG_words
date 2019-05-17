class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper


  # ログイン済みユーザーかどうか確認
  def logged_in_user
    # puts  "logged_in_user"
    # unless logged_in?
    #   flash[:danger] = "Please log in."
    #   redirect_to login_url
    # end
  end

end
