class DashboardController < ApplicationController
  before_action :set_session, except: []

  def index
    @auth_url = session[:oauth].url_for_oauth_code(
      permission: 'public_profile'
    )
  end

  def show
    if params[:code]
      session[:access_token] = session[:oauth].get_access_token params[:code]
    end
    @api = get_api session[:access_token]
    begin
      @profile = @api.get_object "me"
      @friends = @api.get_object "me/friends"
    end
  end

  private

  def set_session
    session[:oauth] = Koala::Facebook::OAuth.new(
      ENV['APP_ID'],
      ENV['APP_SECRET'],
      ENV['SITE_URL'] + '/home/show'
    )
  end

  def get_api(access_token)
    Koala::Facebook::API.new access_token
  end


end
