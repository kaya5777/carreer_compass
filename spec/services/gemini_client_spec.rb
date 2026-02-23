require 'rails_helper'

RSpec.describe GeminiClient do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("GEMINI_API_KEY").and_return("test_api_key")
    stub_const("GeminiClient::MAX_RETRIES", 0)
    stub_const("GeminiClient::RETRY_DELAY", 0)
  end

  describe "#generate" do
    it "returns generated text" do
      stub_gemini_generate("テスト回答です")
      client = described_class.new
      result = client.generate(
        messages: [{ role: "user", content: "テスト質問" }]
      )
      expect(result).to eq("テスト回答です")
    end

    it "includes system prompt when provided" do
      stub_gemini_generate("回答")
      client = described_class.new
      result = client.generate(
        messages: [{ role: "user", content: "質問" }],
        system_prompt: "あなたはアシスタントです"
      )
      expect(result).to eq("回答")
    end

    it "raises ApiError on server error" do
      stub_gemini_error(500)
      client = described_class.new
      expect {
        client.generate(messages: [{ role: "user", content: "test" }])
      }.to raise_error(GeminiClient::ApiError)
    end

    it "raises RateLimitError on 429" do
      stub_gemini_error(429)
      client = described_class.new
      expect {
        client.generate(messages: [{ role: "user", content: "test" }])
      }.to raise_error(GeminiClient::RateLimitError)
    end
  end
end
