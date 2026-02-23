class AiResponseJob < ApplicationJob
  queue_as :default

  def perform(ai_session_id, user_message_content = nil)
    ai_session = AiSession.find(ai_session_id)
    service = build_service(ai_session)

    if user_message_content.present?
      service.instance_variable_set(:@ai_session, ai_session)
      response = service.send_message(user_message_content)
    else
      messages = ai_session.ai_messages.chronological.map do |msg|
        { role: msg.role, content: msg.content }
      end
      client = GeminiClient.new
      response = client.generate(
        messages: messages,
        system_prompt: ai_session.system_prompt
      )
      ai_session.ai_messages.create!(role: :assistant, content: response)
    end

    broadcast_response(ai_session, response)
  rescue GeminiClient::ApiError => e
    Rails.logger.error("AiResponseJob failed: #{e.message}")
    broadcast_error(ai_session, "AI応答の生成に失敗しました。再度お試しください。")
  end

  private

  def build_service(ai_session)
    case ai_session.session_type
    when "strengths_builder"
      StrengthsBuilderService.new(ai_session.user, ai_session.sessionable)
    when "resume_review"
      ResumeReviewService.new(ai_session.user, ai_session.sessionable)
    when "casual_interview_prep"
      CasualInterviewPrepService.new(ai_session.user, ai_session.sessionable)
    when "question_generator"
      QuestionGeneratorService.new(ai_session.user, ai_session.sessionable)
    when "mock_interview"
      MockInterviewService.new(ai_session.user, ai_session.sessionable)
    when "compatibility_diagnosis"
      CompatibilityDiagnosisService.new(ai_session.user, ai_session.sessionable)
    end
  end

  def broadcast_response(ai_session, response)
    Turbo::StreamsChannel.broadcast_append_to(
      "ai_session_#{ai_session.id}",
      target: "messages",
      partial: "shared/ai_message",
      locals: { message: ai_session.ai_messages.last }
    )
  end

  def broadcast_error(ai_session, message)
    Turbo::StreamsChannel.broadcast_append_to(
      "ai_session_#{ai_session.id}",
      target: "messages",
      partial: "shared/ai_error",
      locals: { message: message }
    )
  end
end
