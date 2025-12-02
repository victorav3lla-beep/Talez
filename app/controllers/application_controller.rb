class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def current_profile
    @current_profile ||= Profile.find_by(id: session[:current_profile_id]) if session[:current_profile_id]
  end
  helper_method :current_profile
end
