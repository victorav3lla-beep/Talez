require "tempfile"
require "uri"
require "open-uri"
require "base64"

class AiImageService
  # gpt-image-1 is faster than DALL-E 3 (~5-10s vs ~30s)
  DEFAULT_MODEL = "gpt-image-1"
  DEFAULT_SIZE = "1536x1024"

  def initialize(prompt, size: DEFAULT_SIZE)
    @prompt = prompt.to_s
    @size = size
  end

  def generate
    Rails.logger.info("Generating image with prompt: #{@prompt[0..100]}...")

    image = RubyLLM.paint(@prompt, model: DEFAULT_MODEL, size: @size)

    # gpt-image-1 returns base64 in .data, DALL-E returns URL in .url
    if image&.data
      StringIO.new(Base64.decode64(image.data))
    elsif image&.url
      URI.open(image.url)
    end
  rescue => e
    Rails.logger.error("Image generation failed: #{e.message}")
    nil
  end

  def self.generate(prompt, size: DEFAULT_SIZE)
    new(prompt, size: size).generate
  end
end
