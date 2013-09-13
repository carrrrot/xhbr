class WbStatusesController < ApplicationController

  before_filter :check_login, except: [:login]

  def index
  end

  def check_login
    redirect_to login_path unless cookies[:logged_in] == PASSWORD
  end

  def login
    if request.post?
      cookies[:logged_in] = params[:password]
      redirect_to root_path
    end
  end

  def logout
    cookies[:logged_in] = nil
    redirect_to login_path
  end
end
