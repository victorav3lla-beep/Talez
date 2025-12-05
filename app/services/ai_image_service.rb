require "openai"
require "tempfile"
require "uri"
require "open-uri"

class AiImageService
  def initialize(prompt)
    @prompt = prompt
    # Initialize OpenAI client with your API key from .env
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def generate
    # Generate one image with DALL·E
    response = @client.images.generate(
      parameters: {
        prompt: @prompt,
        n: 1,
        size: "512x512" # change to 256x256 or 1024x1024 if needed cause like size 'n stuff'
      }
    )

    # Get the image URL from the response
    image_url = response.dig("data", 0, "url")
    unless image_url
      Rails.logger.error("Image generation failed, no URL returned: #{response}")
      return nil
    end

    # Download the image into a Tempfile
    file = Tempfile.new(["generated_image", ".png"])
    file.binmode
    file.write(URI.open(image_url).read)
    file.rewind
    file
  rescue => e
    Rails.logger.error("Image generation failed: #{e.message}")
    nil
  end
end
