class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def show_home
    render "home"
  end
end
