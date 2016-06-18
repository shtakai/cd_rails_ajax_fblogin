class DashboardController < ApplicationController
  before_action :set_session

  def index
    @auth_url = session[:oauth].url_for_oauth_code(
      permission: [
        "read_stream"
      ]
    )
    # TODO: button_to can't send parameter after '?'
    #       - use link_to with class that displays as button
    #       - use button_to includes parameter hash
    # @param = @auth_url.split('&')
    # @param.delete_at(0)
  end

  def show
    if params[:code]
      session[:access_token] = session[:oauth].get_access_token params[:code]
    end
    @api = get_api session[:access_token]
    begin
      @profile = @api.get_object("/me")
      @friends = @api.get_connections("me", "friends")
    end
  end

  def logout
    redirect_to "https://www.facebook.com/logout.php?next=http://localhost:3000/dashboard&access_token=#{session[:access_token]}"
  end

  private

  def set_session
    session[:oauth] = Koala::Facebook::OAuth.new(
      ENV['APP_ID'],
      ENV['APP_SECRET'],
      ENV['SITE_URL'] + '/dashboard/show'
    )
    logger.debug '==========='
    logger.debug ENV['APP_ID']
  end

  def get_api(access_token)
    Koala::Facebook::API.new access_token
  end


end
