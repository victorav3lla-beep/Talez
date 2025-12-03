class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_selected_profile, only: [:index, :new, :create]

  def index
    @default_characters = Character.where(profile_id: nil)
    @custom_characters = current_profile ? current_profile.characters : []
    @all_characters = current_profile.characters
  end

  def new
    @character = @selected_profile.characters.build
  end

  def create
    @character = current_profile.characters.build(character_params)
    @character.is_custom = true

    if @character.save
      redirect_to characters_path, notice: "Character created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def select
    @character = Character.find(params[:id])
    session[:selected_character_id] = @character.id
    redirect_to universes_path, notice: "Character selected! Now choose your universe."
  end

  private

  def load_selected_profile
    @selected_profile = current_profile
    unless @selected_profile
      redirect_to profiles_path, alert: "Please select a profile first."
    end
  end

  def character_params
    params.require(:character).permit(:name, :description)
  end
end
