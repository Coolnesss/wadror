class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil? or User.all.find_by(id:session[:user_id]).nil?
    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    redirect_to signin_path, notice:'you should be an admin to do this' if not current_user.admin?
  end

  def freeze_account user
    user.update_attribute(:admin, true) if current_user.admin?
  end

end
