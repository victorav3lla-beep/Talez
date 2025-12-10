require "open-uri"
class UniversesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a kids storybook creator, you specialize in creating modern and appropriate images related to engaging text by helping create story components step by step

    I am a kid looking to create a story, and would appreciate assistance creating aesthetically pleasing stories in an organized way

    Return in JSON format, keys should be ["name", "description"]
  PROMPT
  before_action :authenticate_user!
  before_action :load_selected_profile, only: [:index, :new, :create]

  def index
    @default_universes = Universe.where(profile_id: nil)
    @custom_universes = current_profile ? current_profile.universes : []
    @all_universes = current_profile.universes
  end
  
  def new
    @universe = @selected_profile.universes.build
  end

  def create
    @universe = @selected_profile.universes.build(universe_params)
    @universe.is_custom = true

    unless @universe.valid?
      flash.now[:alert] = @universe.errors.full_messages.first
      render :new, status: :unprocessable_entity
      return
    end

    llm = RubyLLM.chat
    llm.with_instructions(SYSTEM_PROMPT)

    if universe_params[:name].blank?
      response = llm.ask(universe_params[:description])
      begin
        universe_data = JSON.parse(response.content)
        @universe.name = universe_data["name"]
        @universe.description = universe_data["description"]
      rescue JSON::ParserError => e
        redirect_to universes_path, alert: "AI error: #{e.message}"
        return
      end
    end

    character = Character.find_by(id: session[:selected_character_id])

    unless character
      redirect_to characters_path, alert: "Please select a character first"
      return
    end

    image_prompt = <<~PROMPT
      Colorful, animated, kid-friendly storybook illustration for children aged 4–10.
      Wide cinematic landscape view, 16:9 composition, no borders, no text, no UI.
      The main character: #{character.name} - #{character.description} - image: #{character.image.url}
      Setting: #{@universe.name} – #{@universe.description}.
      Style: bright, simple shapes, bold colors, soft lighting, friendly and expressive characters,
      clean background, high contrast, highly detailed but easy to read for kids.
    PROMPT
    image = RubyLLM.paint("#{image_prompt}", model: "dall-e-3", size: "1792x1024")

    if image.url
      image_data = URI.open(image.url)
      @universe.image.attach(
        io: image_data,
        filename: "#{@universe.name.parameterize}.png",
        content_type: "image/png"
      )
    else
      Rails.logger.warn("No image generated for #{@universe.name}")
    end

    if @universe.save
      session[:selected_universe_id] = @universe.id
      redirect_to universe_path(@universe), notice: "Universe created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def select
    @universe = Universe.find(params[:id])
    session[:selected_universe_id] = @universe.id
    redirect_to new_story_path, notice: "Universe selected! Now create your story."
  end

  def show
    @universe = Universe.find(params[:id])
  end

  def destroy
    @universe = current_profile.universes.find(params[:id])
    @universe.destroy
    redirect_to universes_path, notice: "Universe deleted successfully."
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
