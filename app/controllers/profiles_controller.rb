class ProfilesController < ApplicationController
  before_action :authenticate_user!

  # @user = current_user
  def index
    @profiles = Profile.all
    # @profiles = @user.profiles
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def new
    @user = current_user
    @profile = Profile.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)
    if @profile.save
      redirect_to profile_path(@profile), notice: "Profile was successfully created! WOOOOO!!🎉🎉"
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def profile_params
    params.require(:profile).permit(:name, :age, :username)
  end
end
