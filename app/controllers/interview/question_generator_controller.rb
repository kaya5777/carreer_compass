module Interview
  class QuestionGeneratorController < ApplicationController
    def index
      @sessions = current_user.ai_sessions.question_generator.recent
    end

    def show
      @ai_session = current_user.ai_sessions.find(params[:id])
      @messages = @ai_session.ai_messages.chronological
    end

    def create
      service = QuestionGeneratorService.new(
        current_user,
        company_name: params[:company_name],
        position: params[:position],
        interview_type: params[:interview_type],
        additional_info: params[:additional_info],
      )
      @ai_session = service.start_session

      redirect_to interview_question_generator_path(@ai_session)
    end
  end
end
