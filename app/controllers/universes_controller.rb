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

  # def create
  #   @universe = @selected_profile.universes.build(universe_params)
  #   @universe.is_custom = true

  #   if @universe.save
  #     redirect_to universes_path, notice: "Universe created successfully!"
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  def create
    if universe_params[:description].present?
      llm = RubyLLM.chat
      llm.with_instructions(SYSTEM_PROMPT)

      # Generate name if blank
      if universe_params[:name].blank?
        response = llm.ask(universe_params[:description])
        begin
          universe_data = JSON.parse(response.content)
          universe_name = universe_data["name"]
          universe_description = universe_data["description"]
        rescue JSON::ParserError => e
          redirect_to universes_path, alert: "AI error: #{e.message}"
          return
        end
      else
        universe_name = universe_params[:name]
        universe_description = universe_params[:description]
      end

      @universe = @selected_profile.universes.new(
        name: universe_name,
        description: universe_description,
        is_custom: true
      )

      # Generate image using DALL·E 3
      image_prompt = "#{universe_name}: #{universe_description}"
      image = RubyLLM.paint("#{image_prompt}", model: "dall-e-3")

      if image.url
        image_data = URI.open(image.url)
        @universe.image.attach(
          io: image_data,
          filename: "#{universe_name.parameterize}.png",
          content_type: "image/png"
        )
      else
        Rails.logger.warn("No image generated for #{universe_name}")
      end

      if @universe.save
        session[:selected_universe_id] = @universe.id
        redirect_to universe_path(@universe), notice: "Universe created!"
      else
        redirect_to new_universe_path, alert: "Failed to create universe: #{@universe.errors.full_messages.join(', ')}"
      end
    else
      redirect_to universes_path, alert: "Please provide a description"
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
