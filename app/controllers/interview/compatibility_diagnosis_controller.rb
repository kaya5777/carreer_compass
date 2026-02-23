module Interview
  class CompatibilityDiagnosisController < ApplicationController
    def index
      @interview_preps = current_user.interview_preps.order(updated_at: :desc)
      @sessions = current_user.ai_sessions.compatibility_diagnosis.recent
    end

    def show
      @ai_session = current_user.ai_sessions.find(params[:id])
      @messages = @ai_session.ai_messages.chronological
    end

    def create
      interview_prep = current_user.interview_preps.find(params[:interview_prep_id])
      resume = current_user.resumes.find(params[:resume_id]) if params[:resume_id].present?
      service = CompatibilityDiagnosisService.new(current_user, interview_prep, resume)
      @ai_session = service.start_session

      redirect_to interview_compatibility_diagnosis_path(@ai_session)
    end
  end
end
