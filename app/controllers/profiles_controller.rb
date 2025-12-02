class ProfilesController < ApplicationController
  before_action :authenticate_user!

  @user = current_user
  def index
    @profiles = Profile.all(@user)
  end

  def show
    @profile = Profile.find(params[:id])
  end


  private

  def playlist_params
    params.require(:profile).permit(:name, :age, :username)
  end
end
