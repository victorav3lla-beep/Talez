class UniversesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_selected_profile, only: [:index, :new, :create]

  def index
    @default_universes = Universe.where(profile_id: nil)
    @custom_universes = @selected_profile ? @selected_profile.universes : []
  end

  def new
    @universe = @selected_profile.universes.build
  end

  def create
    @universe = @selected_profile.universes.build(universe_params)
    @universe.is_custom = true

    if @universe.save
      redirect_to universes_path, notice: "Universe created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def select
    @universe = Universe.find(params[:id])
    session[:selected_universe_id] = @universe.id
    redirect_to new_story_path, notice: "Universe selected! Now create your story."
  end

  private

  def load_selected_profile
    @selected_profile = current_profile
    unless @selected_profile
      redirect_to profiles_path, alert: "Please select a profile first."
    end
  end

  def universe_params
    params.require(:universe).permit(:name, :description)
  end
end
