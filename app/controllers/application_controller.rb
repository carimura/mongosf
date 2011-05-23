class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :setup_connections

  def setup_connections
    @twitter = TwitterDoor.new
  end

end
