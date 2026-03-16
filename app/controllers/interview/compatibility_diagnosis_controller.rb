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
          redirect_to interview_compatibility_diagnosis_index_path, alert: interview_prep.errors.full_messages.join(", ")
          return
        end
      end

      resume = current_user.resumes.order(updated_at: :desc).first
      service = CompatibilityDiagnosisService.new(current_user, interview_prep, resume)
      @ai_session = service.start_session

      redirect_to interview_compatibility_diagnosis_path(@ai_session)
    end
  end
end
