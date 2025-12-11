require "httparty"
require "base64"

class StabilityService
  ENDPOINT = "https://api.stability.ai/v2beta/stable-image/generate/core"

  def initialize
    @api_key = ENV["STABILITY_API_KEY"]
  end

  def call(prompt, aspect_ratio: "1:1")
    unless @api_key
      Rails.logger.error("StabilityService: STABILITY_API_KEY not set")
      return nil
    end

    response = HTTParty.post(
      ENDPOINT,
      headers: {
        "Authorization" => "Bearer #{@api_key}",
        "Accept" => "application/json"
      },
      multipart: true,
      body: {
        prompt: prompt,
        output_format: "png",
        aspect_ratio: aspect_ratio
      }
    )

    if response.success?
      data = response.parsed_response
      image_base64 = data["image"]

      if image_base64
        Rails.logger.info("StabilityService: Image generated successfully")
        image_base64
      else
        Rails.logger.error("StabilityService: No image in response - #{data}")
        nil
      end
    else
      Rails.logger.error("StabilityService: Request failed - Status: #{response.code}, Body: #{response.body}")
      nil
    end
  rescue StandardError => e
    Rails.logger.error("StabilityService: Exception - #{e.message}")
    Rails.logger.error(e.backtrace.first(5).join("\n"))
    nil
  end

  # Helper to convert base64 to IO for ActiveStorage attachment
  def self.base64_to_io(base64_string, filename: "image.png")
    return nil if base64_string.nil? || base64_string.empty?

    decoded = Base64.decode64(base64_string)
    tempfile = Tempfile.new([filename.to_s.gsub(/\.\w+$/, ""), ".png"])
    tempfile.binmode
    tempfile.write(decoded)
    tempfile.rewind
    tempfile
  rescue StandardError => e
    Rails.logger.error("StabilityService.base64_to_io failed: #{e.message}")
    nil
  end
end
