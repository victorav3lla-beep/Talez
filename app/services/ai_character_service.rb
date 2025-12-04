class AiCharacterService
  require "openai"

  def initialize(prompt)
    @prompt = prompt
    @client = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"])
  end

  def generate
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: @prompt }],
        temperature: 0.7,
        max_tokens: 200
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end
