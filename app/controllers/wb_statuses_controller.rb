class WbStatusesController < ApplicationController
  include ApplicationHelper

  before_filter :check_login, except: [:login]

  WeiboOAuth2::Config.api_key = API_KEY
  WeiboOAuth2::Config.api_secret = API_SECRET
  WeiboOAuth2::Config.redirect_uri = REDIRECT_URI

  def index
  end

  def check_login
    redirect_to login_path unless logged_in?
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

  def help
    @wb_id = session[:uid]
  end

  def connect
    client = WeiboOAuth2::Client.new
    # binding.pry
    # if session[:access_token] && !client.authorized?
    #   token = client.get_token_from_hash({:access_token => session[:access_token], :expires_at => session[:expires_at]}) 
    #   p "*" * 80 + "validated"
    #   p token.inspect
    #   p token.validated?
      
    #   unless token.validated?
    #     reset_session
    #     redirect client.authorize_url
    #     return
    #   end
    # end
    # redirect_to help_path
    redirect_to client.authorize_url
  end

  def callback
    client = WeiboOAuth2::Client.new
    access_token = client.auth_code.get_token(params[:code].to_s)
    wb_id = session[:uid] = access_token.params["uid"]
    token_value = session[:access_token] = access_token.token
    expires_at = session[:expires_at] = access_token.expires_at
    user = client.users.show_by_uid(session[:uid].to_i)

    @wb_user = WbUser.where(wb_id: wb_id).first_or_initialize
    @wb_user.name = user.name
    # @wb_user.screen_name = user.screen_name

    @wb_user.build_wb_access_token(value: token_value, expires_at: expires_at)
    @wb_user.save!
    # session[:user] = @user
    redirect_to help_path
  end
end
