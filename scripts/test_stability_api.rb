# Test Stability AI API connection
# Run with: rails runner scripts/test_stability_api.rb

puts "Testing Stability AI API..."
puts "API Key present: #{ENV['STABILITY_API_KEY'].present?}"

if ENV["STABILITY_API_KEY"].blank?
  puts "ERROR: STABILITY_API_KEY not set in environment"
  exit 1
end

service = StabilityService.new
result = service.call("A red apple on a white background, simple illustration")

if result
  puts "SUCCESS! Received Base64 image (#{result.length} characters)"
  puts "First 100 chars: #{result[0..99]}..."

  # Optionally save to file to verify
  decoded = Base64.decode64(result)
  File.open(Rails.root.join("tmp", "test_stability_image.png"), "wb") do |f|
    f.write(decoded)
  end
  puts "Image saved to tmp/test_stability_image.png"
else
  puts "FAILED: No image returned. Check Rails logs for details."
  exit 1
end
