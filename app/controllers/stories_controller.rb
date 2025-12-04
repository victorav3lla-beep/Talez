class StoriesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a kids storybook creator, you specialize in creating modern and appropriate images related to engaging text by helping create story components step by step
    I am a kid looking to create a story, and would appreciate assistance creating aesthetically pleasing stories in an organized way
    Return in JSON format, keys should be ["title", "content"]
  PROMPT

  def new
    @story = Story.new
  end

    def create
      @ruby_llm = RubyLLM.chat
      @story = Story.new(story_params)
      @story.profile = current_profile
      response = @ruby_llm.with_instructions(SYSTEM_PROMPT).ask(story_params[:content])
      response = JSON.parse(response.content)
      if @story.update(response)
        redirect_to story_path(@story), notice: "Story created successfully!"
      else
        render :new, status: :unprocessable_entity
      end
  end

  def show
    @story = Story.find(params[:id])
  end

  private

  def story_params
    params.require(:story).permit(:content)
  end
end
