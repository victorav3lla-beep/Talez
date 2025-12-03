class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_selected_profile, only: [:index]

  def index
    @default_characters = Character.where(profile_id: nil)
    @custom_characters = @selected_profile ? @selected_profile.characters : []
    @all_characters = Character.for_profile(@selected_profile)
  end

  private

  def load_selected_profile
    if session[:selected_profile_id]
      @selected_profile = current_user.profiles.find_by(id: session[:selected_profile_id])
    end
  end
end
