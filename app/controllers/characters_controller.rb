class CharactersController < ApplicationController
  before_action :authenticate_user!

  def index
    @characters = Character.where(profile_id: [nil, current_profile.id])
    @default_characters = Character.where(profile_id: nil)
    @custom_characters = current_profile ? current_profile.characters : []
    @all_characters = current_profile.characters
  end
end
