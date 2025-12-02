class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @profiles = current_user.profiles
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def select
    profile = Profile.find(params[:id])
    session[:current_profile_id] = profile.id
    redirect_to dashboard_path, notice: "Let's go, #{profile.username}!"
  end

  def new
    @user = current_user
    @profile = Profile.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)
    if @profile.save
      redirect_to profiles_path, notice: "Profile created! 🎉"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :age, :username, :avatar_url) 
  end
end
