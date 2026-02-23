module AiConversable
  extend ActiveSupport::Concern

  included do
    attr_reader :ai_session
  end

  def start_session
    @ai_session = create_session
    initial_message = build_initial_message
    if initial_message.present?
      add_user_message(initial_message)
      generate_ai_response
    end
    @ai_session
  end

  def send_message(content)
    add_user_message(content)
    generate_ai_response
  end

  def send_message_with_stream(content, &block)
    add_user_message(content)
    generate_ai_response_stream(&block)
  end

  private

  def create_session
    raise NotImplementedError, "Subclass must implement #create_session"
  end

  def build_initial_message
    raise NotImplementedError, "Subclass must implement #build_initial_message"
  end

  def system_prompt
    raise NotImplementedError, "Subclass must implement #system_prompt"
  end

  def add_user_message(content)
    @ai_session.ai_messages.create!(role: :user, content: content)
  end

  def add_assistant_message(content)
    @ai_session.ai_messages.create!(role: :assistant, content: content)
  end

  def generate_ai_response
    messages = format_messages_for_api
    client = GeminiClient.new
    response = client.generate(
      messages: messages,
      system_prompt: @ai_session.system_prompt
    )
    add_assistant_message(response)
    response
  end

  def generate_ai_response_stream(&block)
    messages = format_messages_for_api
    client = GeminiClient.new
    full_response = client.stream(
      messages: messages,
      system_prompt: @ai_session.system_prompt,
      &block
    )
    add_assistant_message(full_response)
    full_response
  end

  def format_messages_for_api
    @ai_session.ai_messages.chronological.map do |msg|
      { role: msg.role, content: msg.content }
    end
  end
end
