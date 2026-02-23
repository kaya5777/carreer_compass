class AiMessagesController < ApplicationController
  include AiErrorHandling

  def send_message
    @ai_session = current_user.ai_sessions.find(params[:ai_session_id])
    content = params[:content]&.strip

    if content.blank?
      head :unprocessable_entity
      return
    end

    service = build_service(@ai_session)
    service.instance_variable_set(:@ai_session, @ai_session)
    response = service.send_message(content)

    @assistant_message = @ai_session.ai_messages.where(role: :assistant).last

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to polymorphic_session_path(@ai_session) }
    end
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

  def polymorphic_session_path(ai_session)
    case ai_session.session_type
    when "strengths_builder" then preparation_strengths_builder_path(ai_session)
    when "resume_review" then preparation_resume_review_path(ai_session)
    when "casual_interview_prep" then preparation_casual_interview_prep_path(ai_session)
    when "question_generator" then interview_question_generator_path(ai_session)
    when "mock_interview" then interview_mock_interview_path(ai_session)
    when "compatibility_diagnosis" then interview_compatibility_diagnosis_path(ai_session)
    else dashboard_path
    end
  end
end
