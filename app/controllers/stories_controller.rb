class StoriesController < ApplicationController
  before_action :authenticate_user!

  def show
    @story = current_user.stories.find(params[:id])
  end

  def new
    @story = current_user.stories.build
  end

  def create
    @story = current_user.stories.build(story_params)

    if @story.save
      redirect_to story_path(@story), notice: "Story created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def story_params
    params.require(:story).permit(:title, :universe_id)
  end
end
