class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_profile

  def index
    @profile = current_profile

    @my_stories = @profile.stories.includes(:characters, :universes, :chats).order(updated_at: :desc)

    @bookmarked_stories = @profile.bookmarks.includes(story: [:characters, :universes, :chats]).map(&:story)

    @continue_reading = @my_stories.where(status: 'draft').first
  end

  private

  def require_profile
    unless session[:current_profile_id].present? && current_profile.present?
      session[:current_profile_id] = nil
      redirect_to profiles_path, alert: "Please select a profile first"
    end
  end

  def current_profile
    @current_profile ||= Profile.find_by(id: session[:current_profile_id])
  end
end
