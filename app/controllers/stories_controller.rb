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
    @story = Story.new
    @story.profile = current_profile
    character = Character.find(session[:selected_character_id])
    universe = Universe.find(session[:selected_universe_id])
    response = @ruby_llm.with_instructions(instructions(character, universe)).ask(story_params[:content])
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

  def instructions(character, universe)
    <<~PROMPT
      You are a kids storybook creator, you specialize in creating modern and appropriate images related to engaging text by helping create story components step by step

      I am a kid looking to create a story, and would appreciate assistance creating aesthetically pleasing stories in an organized way

      The main character of my story is described as follows:
      Name: #{character.name}
      Description: #{character.description}

      The universe of my story is described as follows:
      Name: #{universe.name}
      Description: #{universe.description}

      Please help me create a story that fits within this context.
      Return in JSON format, keys should be ["title", "content"]
    PROMPT
  end
end
