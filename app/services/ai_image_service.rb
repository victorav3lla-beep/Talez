require "tempfile"
require "uri"
require "open-uri"

class AiImageService
  # Flux Schnell is much faster than DALL-E 3 (2-5 seconds vs 30+ seconds)
  DEFAULT_MODEL = "black-forest-labs/flux-schnell"

  def initialize(prompt, aspect_ratio: "16:9")
    @prompt = prompt
    @aspect_ratio = aspect_ratio
  end

  def generate
    output = Replicate.run(
      DEFAULT_MODEL,
      input: {
        prompt: @prompt,
        aspect_ratio: @aspect_ratio,
        num_outputs: 1,
        output_format: "png"
      }
    )

    # Flux Schnell returns an array of URLs
    image_url = output.is_a?(Array) ? output.first : output
    unless image_url
      Rails.logger.error("Image generation failed, no URL returned")
      return nil
    end

    image_url
  rescue => e
    Rails.logger.error("Image generation failed: #{e.message}")
    nil
  end

  def generate_file
    image_url = generate
    return nil unless image_url

    file = Tempfile.new(["generated_image", ".png"])
    file.binmode
    file.write(URI.open(image_url).read)
    file.rewind
    file
  rescue => e
    Rails.logger.error("Image file download failed: #{e.message}")
    nil
  end

  # Class method for quick generation
  def self.generate(prompt, aspect_ratio: "16:9")
    new(prompt, aspect_ratio: aspect_ratio).generate
  end
end
