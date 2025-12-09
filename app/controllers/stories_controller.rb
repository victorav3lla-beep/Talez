require "open-uri"

class StoriesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a kids storybook creator, you specialize in creating modern and appropriate images related to engaging text by helping create story components step by step
    I am a kid looking to create a story, and would appreciate assistance creating aesthetically pleasing stories in an organized way
    Return in JSON format, keys should be ["title", "content"]
  PROMPT

  def new
    @story = Story.new
  end

  def index
    # Featured carousel - 5 most-liked public stories
    @featured_stories = Story.where(public: true).order(likes_count: :desc).limit(5)

    # Filter logic
    filter = params[:filter] || 'popular'

    case filter
    when 'recent'
      @stories = Story.where(public: true).order(created_at: :desc)
    when 'my_stories'
      @stories = current_profile.stories.order(updated_at: :desc)
    else # popular
      @stories = Story.where(public: true).order(likes_count: :desc, updated_at: :desc)
    end

    @current_filter = filter
  end

  def create
    @ruby_llm = RubyLLM.chat
    @story = Story.new
    @story.profile = current_profile

    character = Character.find(session[:selected_character_id])
    universe = Universe.find(session[:selected_universe_id])

    response = @ruby_llm.with_instructions(instructions(character, universe)).ask(story_params[:content])
    response = JSON.parse(response.content)

    if @story.save
      @story.update(title: response["title"])
      response_text = response["content"]

      # Create first page (beginning of the story)
      page = @story.pages.create(
        title: response["title"],
        content: response_text,
        position: 1,
      )

      # Generate and attach page image
      page_image_prompt = "Animated, kid-friendly illustration of: #{response_text}\nStyle: bright, simple shapes, bold colors, friendly characters, no text, high contrast\nFormat: wide landscape, 16:9 aspect ratio, horizontal composition"
      page_image = RubyLLM.paint(page_image_prompt, model: "dall-e-3")

      if page_image.url
        page_image_data = URI.open(page_image.url)
        page.image.attach(
          io: page_image_data,
          filename: "page-#{SecureRandom.hex(4)}.png",
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

  def update
    @story = Story.find(params[:id])

    if @story.profile == current_profile
      if @story.update(story_update_params)
        redirect_back(fallback_location: stories_path, notice: "Story updated successfully!")
      else
        redirect_back(fallback_location: stories_path, alert: "Could not update story")
      end
    else
      redirect_back(fallback_location: stories_path, alert: "Unauthorized")
    end
  end

  def add_page
    @story = Story.find(params[:id])
    @ruby_llm = RubyLLM.chat

    character = Character.find(session[:selected_character_id])
    universe = Universe.find(session[:selected_universe_id])

    # Determine which part of the story we're adding
    next_position = @story.pages.count + 1
    story_part = case next_position
                 when 2 then "problem"
                 when 3 then "resolution"
                 else "continuation"
                 end

    response = @ruby_llm.with_instructions(continuation_instructions(character, universe, story_part)).ask(page_params[:content])
    response = JSON.parse(response.content)

    # Create the new page
    page = @story.pages.create(
      title: response["title"],
      content: response["content"],
      position: next_position
    )

    # Generate and attach page image
    page_image_prompt = "Animated, kid-friendly illustration of: #{response['content']}\nStyle: bright, simple shapes, bold colors, friendly characters, no text, high contrast\nFormat: wide landscape, 16:9 aspect ratio, horizontal composition"
    page_image = RubyLLM.paint(page_image_prompt, model: "dall-e-3")

    if page_image.url
      page_image_data = URI.open(page_image.url)
      page.image.attach(
        io: page_image_data,
        filename: "page-#{SecureRandom.hex(4)}.png",
        content_type: "image/png"
      )
    end

    # If this is the resolution (page 3), generate the cover
    if next_position == 3
      generate_cover
    end

    redirect_to story_path(@story), notice: "Page added successfully!"
  end

  def destroy
    @story = Story.find(params[:id])
    @story.destroy
    redirect_to stories_path, notice: "Story deleted successfully."
  end

  private

  def story_params
    params.require(:story).permit(:content)
  end

  def story_update_params
    params.require(:story).permit(:public)
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

    def page_params
    params.require(:page).permit(:content)
  end

  def continuation_instructions(character, universe, story_part)
    existing_content = @story.pages.order(:position).pluck(:content).join("\n\n")

    <<~PROMPT
      You are a kids animated storybook creator.

      The main character: #{character.name} - #{character.description}
      The universe: #{universe.name} - #{universe.description}

      Story so far:
      #{existing_content}

      Please create the #{story_part} of the story.
      Return in JSON format, keys should be ["title", "content"]
    PROMPT
  end

  def generate_cover
    cover_prompt = "Animated, kid-friendly book cover illustration for: #{@story.title}\nStyle: bright, simple shapes, bold colors, friendly characters, high contrast, professional book cover layout\nFormat: wide landscape, 16:9 aspect ratio, horizontal composition, with no book margins, just the image"
    cover_image = RubyLLM.paint(cover_prompt, model: "dall-e-3")

    if cover_image.url
      cover_data = URI.open(cover_image.url)
      @story.cover.attach(
        io: cover_data,
        filename: "cover-#{SecureRandom.hex(4)}.png",
        content_type: "image/png"
      )
    end
  end
end
