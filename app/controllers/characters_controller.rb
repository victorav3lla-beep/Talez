require "open-uri"
class CharactersController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a kids storybook creator, you specialize in creating modern and appropriate images related to engaging text by helping create story components step by step

    I am a kid looking to create a story, and would appreciate assistance creating aesthetically pleasing stories in an organized way

    Return in JSON format, keys should be ["name", "description"]
  PROMPT
  before_action :authenticate_user!
  before_action :load_selected_profile, only: [:index, :new, :create]

  def index
    @default_characters = Character.where(profile_id: nil)
    @custom_characters = current_profile ? current_profile.characters : []
    @all_characters = current_profile.characters
  end

  def new
    @character = @selected_profile.characters.build
  end

  # def create
  #   # @character = current_profile.characters.build(character_params)
  #   # @character.is_custom = true

  #   # if @character.save
  #   #   redirect_to characters_path, notice: "Character created successfully!"
  #   # else
  #   #   render :new, status: :unprocessable_entity
  #   # end
  # end

  def create
    if character_params[:description].present?
      llm = RubyLLM.chat
      llm.with_instructions(SYSTEM_PROMPT)

      if character_params[:name].blank?
        response = llm.ask(character_params[:description])
        begin
          character_data = JSON.parse(response.content)
          character_name = character_data["name"]
          character_description = character_data["description"]
        rescue JSON::ParserError => e
          redirect_to characters_path, alert: "AI error: #{e.message}"
          return
        end
      else
        character_name = character_params[:name]
        character_description = character_params[:description]
      end

      @character = @selected_profile.characters.new(
        name: character_name,
        description: character_description,
        is_custom: true,
      )

      image_prompt = "#{character_name}: #{character_description}"
      image = RubyLLM.paint("#{image_prompt}", model: "dall-e-3")

      if image.url
        image_data = URI.open(image.url)

        @character.image.attach(
          io: image_data,
          filename: "#{character_name.parameterize}.png",
          content_type: "image/png",
        )
      else
        Rails.logger.warn("No image generated for #{character_name}")
      end

      if @character.save
        session[:selected_character_id] = @character.id
        redirect_to character_path(@character), notice: "Character created!"
      else
        redirect_to new_character_path, alert: "Failed to create character: #{@character.errors.full_messages.join(", ")}"
      end
    else
      redirect_to characters_path, alert: "Please provide a description"
    end
  end

  def select
    @character = Character.find(params[:id])
    session[:selected_character_id] = @character.id
    redirect_to universes_path, notice: "Character selected! Now choose your universe."
  end

  def try_again
    @character = Character.find(params[:id])
    redirect_to new_character_path(description: @character.description)
  end

  def show
    @character = Character.find(params[:id])
  end

  def destroy
    @character = current_profile.characters.find(params[:id])
    @character.destroy
    redirect_to characters_path, notice: "Character deleted successfully."
  end

  private

  def load_selected_profile
    @selected_profile = current_profile
    unless @selected_profile
      redirect_to profiles_path, alert: "Please select a profile first."
    end
  end

  def character_params
    params.require(:character).permit(:name, :description)
  end
end
