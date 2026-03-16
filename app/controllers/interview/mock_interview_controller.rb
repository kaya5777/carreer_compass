module Interview
  class MockInterviewController < ApplicationController
    def index
      @interview_preps = current_user.interview_preps.order(updated_at: :desc)
      @sessions = current_user.ai_sessions.mock_interview.recent
    end

    def show
      @ai_session = current_user.ai_sessions.find(params[:id])
      @messages = @ai_session.ai_messages.chronological
      @interview_prep = @ai_session.sessionable
    end

    def create
      if params[:interview_prep_id].present?
        interview_prep = current_user.interview_preps.find(params[:interview_prep_id])
      else
        interview_prep = current_user.interview_preps.build(
          company_name: params[:company_name],
          job_posting: params[:job_posting],
          company_info: params[:company_info],
          interview_type: :formal,
          status: :draft
        )
        unless interview_prep.save
          redirect_to interview_mock_interview_index_path, alert: interview_prep.errors.full_messages.join(", ")
          return
        end
      end

      service = MockInterviewService.new(current_user, interview_prep)
      @ai_session = service.start_session

      redirect_to interview_mock_interview_path(@ai_session)
    end
  end
end
