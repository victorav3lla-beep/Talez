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
    @all_universes = current_profile&.universes || []
  end
  
  def new
    @universe = @selected_profile.universes.build
  end

  def create
    Rails.logger.info "=== UNIVERSE PARAMS DEBUG: #{params.inspect} ==="
    Rails.logger.info "=== UNIVERSE STYLE FROM PARAMS: '#{params.dig(:universe, :style)}' ==="

    selected_style = params.dig(:universe, :style).presence || "cartoon"
    uni_attrs = universe_params.to_h.except("style")
    @universe = @selected_profile.universes.build(uni_attrs)
    @universe.is_custom = true

    unless @universe.valid?
      flash.now[:alert] = @universe.errors.full_messages.first
      render :new, status: :unprocessable_entity
      return
    end

    llm = RubyLLM.chat
    llm.with_instructions(SYSTEM_PROMPT)

    if uni_attrs["name"].blank?
      response = llm.ask(uni_attrs["description"])
      begin
        universe_data = JSON.parse(response.content)
        @universe.name = universe_data["name"]
        @universe.description = universe_data["description"]
      rescue JSON::ParserError => e
        redirect_to universes_path, alert: "AI error: #{e.message}"
        return
      end
    end

    Rails.logger.info "=== UNIVERSE STYLE DEBUG: selected_style = '#{selected_style}' ==="

    style_description = case selected_style
      when "manga" then "Japanese manga/anime style with vibrant colors, dynamic composition, cel-shaded coloring"
      when "storybook" then "classic children's storybook illustration, soft painterly style, warm and cozy"
      when "pixel art" then "retro pixel art style, 16-bit video game aesthetic, crisp pixels"
      when "watercolor" then "soft watercolor painting style, gentle washes of color, artistic brushstrokes"
      when "sketch" then "hand-drawn pencil sketch style, charming linework, minimal coloring"
      else "bright cartoon style, bold colors, simple shapes, friendly and expressive"
    end

    Rails.logger.info "=== UNIVERSE STYLE DEBUG: style_description = '#{style_description}' ==="

    image_prompt = <<~PROMPT
      #{style_description} illustration.
      Wide cinematic landscape, 16:9 composition, no borders, no text, no UI.
      Setting: #{@universe.name} – #{@universe.description}.
      Kid-friendly for children aged 4–10, high contrast, easy to read.
      Focus on environment and atmosphere only. NO characters or people.
      Art style: #{style_description}.
    PROMPT

    Rails.logger.info "=== UNIVERSE IMAGE PROMPT: #{image_prompt} ==="

    image_base64 = StabilityService.new.call(image_prompt, aspect_ratio: "16:9")

    if image_base64
      image_io = StabilityService.base64_to_io(image_base64, filename: @universe.name.parameterize)
      if image_io
        @universe.image.attach(
          io: image_io,
          filename: "#{@universe.name.parameterize}.png",
          content_type: "image/png"
        )
      else
        Rails.logger.warn("Failed to decode image for #{@universe.name}")
      end
    else
      Rails.logger.warn("No image generated for #{@universe.name}")
    end

    if @universe.save
      session[:selected_universe_id] = @universe.id
      redirect_to universe_path(@universe), notice: "Universe created with style: #{selected_style}"
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
      return
    end
  end

  def universe_params
    params.require(:universe).permit(:name, :description, :style)
  end
end
