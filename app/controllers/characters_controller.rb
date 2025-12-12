require "open-uri"
class CharactersController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a kids storybook creator, you specialize in creating modern and appropriate images related to engaging text by helping create story components step by step

    I am a kid looking to create a story, and would appreciate assistance creating a aesthetically pleasing character for my stories

    Return in JSON format, keys should be ["name", "description"]
  PROMPT
  before_action :authenticate_user!
  before_action :load_selected_profile, only: [:index, :new, :create]

  def index
    @default_characters = Character.where(profile_id: nil)
    @custom_characters = current_profile ? current_profile.characters : []
    @all_characters = current_profile&.characters || []
  end

  def new
    @character = @selected_profile.characters.build
  end

  def create
    Rails.logger.info "=== CHARACTER PARAMS DEBUG: #{params.inspect} ==="
    Rails.logger.info "=== CHARACTER STYLE FROM PARAMS: '#{params.dig(:character, :style)}' ==="

    selected_style = params.dig(:character, :style).presence || "cartoon"
    char_attrs = character_params.to_h.except("style")
    @character = @selected_profile.characters.build(char_attrs)
    @character.is_custom = true

    unless @character.valid?
      flash.now[:alert] = @character.errors.full_messages.first
      render :new, status: :unprocessable_entity
      return
    end

    llm = RubyLLM.chat
    llm.with_instructions(SYSTEM_PROMPT)

    if char_attrs["name"].blank?
      response = llm.ask(char_attrs["description"])
      begin
        character_data = JSON.parse(response.content)
        @character.name = character_data["name"]
        @character.description = character_data["description"]
      rescue JSON::ParserError => e
        redirect_to characters_path, alert: "AI error: #{e.message}"
        return
      end
    end

    Rails.logger.info "=== CHARACTER STYLE DEBUG: selected_style = '#{selected_style}' ==="

    style_description = case selected_style
      when "manga" then "Japanese manga/anime style with big expressive eyes, dynamic poses, cel-shaded coloring"
      when "storybook" then "classic children's storybook illustration, soft painterly style, warm and cozy"
      when "pixel art" then "retro pixel art style, 16-bit video game aesthetic, crisp pixels"
      when "watercolor" then "soft watercolor painting style, gentle washes of color, artistic brushstrokes"
      when "sketch" then "hand-drawn pencil sketch style, charming linework, minimal coloring"
      else "bright cartoon style, bold colors, simple shapes, friendly and expressive"
    end

    Rails.logger.info "=== CHARACTER STYLE DEBUG: style_description = '#{style_description}' ==="

    image_prompt = <<~PROMPT
      #{style_description}.
      Full-body character portrait: #{@character.name} - #{@character.description}.
      Single character only, clean background.
      MUST BE #{style_description.upcase}.
    PROMPT

    Rails.logger.info "=== CHARACTER IMAGE PROMPT: #{image_prompt} ==="

    image_base64 = StabilityService.new.call(image_prompt)

    if image_base64
      image_io = StabilityService.base64_to_io(image_base64, filename: @character.name.parameterize)
      if image_io
        @character.image.attach(
          io: image_io,
          filename: "#{@character.name.parameterize}.png",
          content_type: "image/png"
        )
      else
        Rails.logger.warn("Failed to decode image for #{@character.name}")
      end
    else
      Rails.logger.warn("No image generated for #{@character.name}")
    end

    if @character.save
      session[:selected_character_id] = @character.id
      redirect_to character_path(@character), notice: "Character created with style: #{selected_style}"
    else
      render :new, status: :unprocessable_entity
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
      return
    end
  end

  def character_params
    params.require(:character).permit(:name, :description, :style)
  end
end
