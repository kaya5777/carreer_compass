class GeminiClient
  API_BASE_URL = "https://generativelanguage.googleapis.com/v1beta"
  DEFAULT_MODEL = "gemini-2.5-flash"
  MAX_RETRIES = 3
  RETRY_DELAY = 1

  class ApiError < StandardError; end
  class RateLimitError < ApiError; end
  class InvalidResponseError < ApiError; end

  def initialize(model: DEFAULT_MODEL)
    @model = model
    @api_key = ENV.fetch("GEMINI_API_KEY")
    @conn = build_connection
  end

  def generate(messages:, system_prompt: nil, temperature: 0.7)
    body = build_request_body(messages, system_prompt, temperature)
    response = with_retries do
      @conn.post(generate_url, body.to_json)
    end
    parse_response(response)
  end

  def stream(messages:, system_prompt: nil, temperature: 0.7, &block)
    body = build_request_body(messages, system_prompt, temperature)
    full_response = ""

    with_retries do
      @conn.post(stream_url, body.to_json) do |req|
        req.options.on_data = proc do |chunk, _size, _env|
          parsed = parse_stream_chunk(chunk)
          if parsed
            full_response += parsed
            block.call(parsed) if block
          end
        end
      end
    end

    full_response
  end

  private

  def build_connection
    Faraday.new do |f|
      f.headers["Content-Type"] = "application/json"
      f.options.timeout = 120
      f.options.open_timeout = 10
      f.adapter Faraday.default_adapter
    end
  end

  def generate_url
    "#{API_BASE_URL}/models/#{@model}:generateContent?key=#{@api_key}"
  end

  def stream_url
    "#{API_BASE_URL}/models/#{@model}:streamGenerateContent?alt=sse&key=#{@api_key}"
  end

  def build_request_body(messages, system_prompt, temperature)
    body = {
      contents: format_messages(messages),
      generationConfig: {
        temperature: temperature,
        maxOutputTokens: 8192
      }
    }

    if system_prompt.present?
      body[:systemInstruction] = {
        parts: [ { text: system_prompt } ]
      }
    end

    body
  end

  def format_messages(messages)
    messages.map do |msg|
      {
        role: msg[:role] == "assistant" ? "model" : "user",
        parts: [ { text: msg[:content] } ]
      }
    end
  end

  def parse_response(response)
    unless response.success?
      handle_error_response(response)
    end

    data = JSON.parse(response.body)
    extract_text(data)
  rescue JSON::ParserError => e
    raise InvalidResponseError, "Failed to parse response: #{e.message}"
  end

  def parse_stream_chunk(chunk)
    chunk.split("\n").filter_map do |line|
      next unless line.start_with?("data: ")
      json_str = line.sub("data: ", "")
      next if json_str.blank?
      data = JSON.parse(json_str)
      extract_text(data)
    rescue JSON::ParserError
      nil
    end.join
  end

  def extract_text(data)
    data.dig("candidates", 0, "content", "parts", 0, "text") || ""
  end

  def handle_error_response(response)
    case response.status
    when 429
      raise RateLimitError, "Rate limit exceeded"
    when 400..499
      raise ApiError, "Client error (#{response.status}): #{response.body}"
    when 500..599
      raise ApiError, "Server error (#{response.status}): #{response.body}"
    else
      raise ApiError, "Unexpected error (#{response.status}): #{response.body}"
    end
  end

  def with_retries(&block)
    retries = 0
    begin
      block.call
    rescue Faraday::Error, ApiError => e
      retries += 1
      if retries <= MAX_RETRIES && retryable?(e)
        sleep(RETRY_DELAY * retries)
        retry
      end
      raise
    end
  end

  def retryable?(error)
    case error
    when RateLimitError then true
    when Faraday::TimeoutError then true
    when Faraday::ConnectionFailed then true
    when ApiError then error.message.include?("Server error")
    else false
    end
  end
end
