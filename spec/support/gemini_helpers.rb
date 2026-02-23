module GeminiHelpers
  def stub_gemini_generate(response_text = "AI response")
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(
        status: 200,
        body: {
          candidates: [
            { content: { parts: [{ text: response_text }], role: "model" } }
          ]
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def stub_gemini_stream(response_text = "AI response")
    chunks = response_text.chars.each_slice(10).map(&:join)
    body = chunks.map do |chunk|
      "data: #{({ candidates: [{ content: { parts: [{ text: chunk }], role: 'model' } }] }).to_json}\n\n"
    end.join

    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(
        status: 200,
        body: body,
        headers: { "Content-Type" => "text/event-stream" }
      )
  end

  def stub_gemini_error(status = 500)
    stub_request(:post, /generativelanguage\.googleapis\.com/)
      .to_return(status: status, body: { error: { message: "API Error" } }.to_json)
  end
end

RSpec.configure do |config|
  config.include GeminiHelpers
end
