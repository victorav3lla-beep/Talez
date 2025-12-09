class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @story = Story.find(params[:story_id])
    @like = @story.likes.build(profile: current_profile)

    if @like.save
      @story.increment!(:likes_count)
      respond_to do |format|
        format.html { redirect_back(fallback_location: stories_path, notice: 'Story liked!') }
        format.json { render json: { likes_count: @story.likes_count, liked: true }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: stories_path, alert: 'Could not like story') }
        format.json { render json: { error: 'Could not like story' }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @story = @like.story

    if @like.profile == current_profile && @like.destroy
      @story.decrement!(:likes_count)
      respond_to do |format|
        format.html { redirect_back(fallback_location: stories_path, notice: 'Like removed') }
        format.json { render json: { likes_count: @story.likes_count, liked: false }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: stories_path, alert: 'Could not remove like') }
        format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
      end
    end
  end
end
