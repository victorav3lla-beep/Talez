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
      response_text = response["content"] || response_content_from_llm
      image_prompt = "Animated, kid-friendly illustration of: #{response_text}\nStyle: bright, simple shapes, bold colors, friendly characters, no text, high contrast, 16:9"

      # image_file = AiImageService.new(image_prompt).generate
      image = RubyLLM.paint("#{response_text}", model: "dall-e-3")

      if image.url
        # Always use a random filename since there's no name field
        filename = "story-#{SecureRandom.hex(4)}"

        image_data = URI.open(image.url)

        @story.images.attach(
          io: image_data,
          filename: "#{filename}.png",
          content_type: "image/png",
        )
      end

      # Redirect after successfully updating the story and attaching the image
      redirect_to story_path(@story), notice: "Story image created successfully!"
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
      You are a kids animated storybook creator, you specialize in creating modern and appropriate images related to engaging text by helping create story components step by step

      I am a kid looking to create a story, and would appreciate assistance creating aesthetically pleasing stories in an organized way

      The main character of my story is described as follows:
      Name: #{character.name}
      Description: #{character.description}

      The universe of my story is described as follows:
      Name: #{universe.name}
      Description: #{universe.description}

      Please help me create the beggining of a story that fits within this context, then I will continue with the problem and the ending.
      Return in JSON format, keys should be ["title", "content"]
    PROMPT
  end
end
