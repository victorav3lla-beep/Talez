class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_profile

  def index
    @profile = current_profile
    @my_stories = @profile.stories.includes(:characters, :universes, :chats).order(updated_at: :desc)
    @bookmarked_stories = @profile.bookmarked_stories.includes(:characters, :universes, :chats).order(updated_at: :desc)
    @continue_reading = @my_stories.where(status: 'draft').first
  end

  private

  def require_profile
    unless current_profile
      redirect_to profiles_path, alert: "Please select a profile first"
    end
  end
end
