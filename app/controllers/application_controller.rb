class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    # Permit the `username` parameter along with the other
    # sign up parameters.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name])
  end

  def current_profile
    @current_profile ||= Profile.find_by(id: session[:current_profile_id]) if session[:current_profile_id]
  end
  helper_method :current_profile
end
