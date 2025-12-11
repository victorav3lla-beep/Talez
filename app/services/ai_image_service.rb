require "tempfile"
require "uri"
require "open-uri"

class AiImageService
  # gpt-image-1 is faster and more consistent than DALL-E 3
  DEFAULT_MODEL = "gpt-image-1"
  DEFAULT_SIZE = "1536x1024"  # Landscape, closest to 16:9

  def initialize(prompt, size: DEFAULT_SIZE)
    @prompt = prompt
    @size = size
  end

  def generate
    image = RubyLLM.paint(@prompt, model: DEFAULT_MODEL, size: @size)
    image&.url
  rescue => e
    Rails.logger.error("Image generation failed: #{e.message}")
    nil
  end

  # Class method for quick generation
  def self.generate(prompt, size: DEFAULT_SIZE)
    new(prompt, size: size).generate
  end
end
