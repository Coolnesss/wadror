class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.banned?
      redirect_to :back, notice: "You are banned. Get lost!"
      return
    end
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end

  def create_oauth
    nick = env["omniauth.auth"].info.nickname
    if ((User.find_by username:nick).nil?) then
      pass = ((0...8).map { (65 + rand(26)).chr }.join) + 123.to_s
      user = User.create(username:nick, password:pass, password_confirmation:pass)
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Thanks for logging in with Github"
    else
      user = (User.find_by username:nick)
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    end
  end

end
