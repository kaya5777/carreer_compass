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
      interview_prep = current_user.interview_preps.find(params[:interview_prep_id])
      service = MockInterviewService.new(current_user, interview_prep)
      @ai_session = service.start_session

      redirect_to interview_mock_interview_path(@ai_session)
    end
  end
end
