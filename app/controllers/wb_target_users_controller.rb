class WbTargetUsersController < ApplicationController
	include ApplicationHelper
  include WbTargetUsersHelper
  include Fetch

  before_filter :check_login, except: [:login]
  before_filter :set_time_zone

  WeiboOAuth2::Config.api_key = API_KEY
  WeiboOAuth2::Config.api_secret = API_SECRET
  WeiboOAuth2::Config.redirect_uri = REDIRECT_URI

  def index
    @wb_target_users = Rails.cache.fetch "index_target_users" do
      # binding.pry
      WbTargetUser.limit(6).order("followers_count desc")
    end
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

  def create
    pair = parse_user_url(params[:account_url])
    wb_id = pair["wb_id"]
    domain = pair["domain"]

    @wb_target_user = WbTargetUser.where("wb_id = ? or lower(replace(domain, '.', '')) = replace(?, '.', '')", wb_id, domain).first

    if !@wb_target_user
      # access_token = WbAccessToken.first # need to randomize the access_token
      access_token = Fetch.random_access_token
      client = WeiboOAuth2::Client.new
      client.get_token_from_hash({:access_token => access_token.value, :expires_at => access_token.expires_at}) 
      # network issue !!!!!
      binding.pry
      if wb_id 
        # api_user = client.users.show_by_uid(wb_id)
        body = RestClient.get 'https://api.weibo.com/2/users/show.json', {:params => {:access_token => access_token.value, :uid => wb_id}}
      elsif domain
        # api_user = client.users.domain_show(domain)
        body = RestClient.get 'https://api.weibo.com/2/users/domain_show.json', {:params => {:access_token => access_token.value, :domain => domain}}
      end
      api_user = JSON(body)
      binding.pry

      @wb_target_user = WbTargetUser.new
      @wb_target_user.set_api_user(api_user)
      @wb_target_user.save!

      access_token.success_count += 1
      access_token.save!
    end

    redirect_to root_path
  end

  def show
    @wb_target_user = WbTargetUser.where("wb_id = ?", params[:id]).first
    frames = @wb_target_user.wb_target_user_frames.order("created_at asc").where("followers_per_hour is not null")
    data = Array.new
    point_start = frames[0].created_at.to_time
    frames.each do |frame|
      data.push [convert_time_to_js_code(frame.created_at.to_time), frame.followers_per_hour.to_i]
    end

    @followers_count_chart = LazyHighCharts::HighChart.new('followers_count_chart') do |f|
      f.chart({
        type: 'spline'
        })
      f.xAxis({
        type: 'datetime'
        })
      f.tooltip({
        xDateFormat: '%m-%d %H:%M:%S'
        })
      f.series({
        name: 'followers_per_hour',
        data: data,
        pointStart: point_start,
        pointInterval: 60 * 1000
        })
    end if data

    @wb_statuses = @wb_target_user.wb_statuses.reverse

    @wb_status_chart = Hash.new
    @wb_statuses.each do |status|
      status_frames = status.wb_status_frames.order("created_at asc")
      attitude_data = Array.new
      comment_data = Array.new
      repost_data = Array.new
      point_start = status_frames[0].created_at.to_time
      status_frames.each do |frame|
        attitude_data.push [convert_time_to_js_code(frame.created_at.to_time), frame.attitudes_count]
        comment_data.push [convert_time_to_js_code(frame.created_at.to_time), frame.comments_count]
        repost_data.push [convert_time_to_js_code(frame.created_at.to_time), frame.reposts_count]
      end
      @wb_status_chart[status.wb_id] = LazyHighCharts::HighChart.new('status_chart') do |f|
        f.chart({
          type: 'spline'
          })
        f.xAxis({
          type: 'datetime'
          })
        f.tooltip({
          xDateFormat: '%m-%d %H:%M:%S'
          })
        f.series({
          name: 'attitudes_count',
          data: attitude_data,
          pointStart: point_start,
          pointInterval: 60 * 1000
          })
        f.series({
          name: 'comments_count',
          data: comment_data,
          pointStart: point_start,
          pointInterval: 60 * 1000
          })
        f.series({
          name: 'reposts_count',
          data: repost_data,
          pointStart: point_start,
          pointInterval: 60 * 1000
          })
      end
    end

    respond_to do |format|
      format.html 
    end
  end
end
