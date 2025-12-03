class UniversesController < ApplicationController
  before_action :authenticate_user!

  def index
    @default_universes = Universe.where(profile_id: nil)
    @custom_universes = current_profile ? current_profile.universes : []
    @all_universes = current_profile.universes
  end
end
