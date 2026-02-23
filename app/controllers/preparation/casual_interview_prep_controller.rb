module Preparation
  class CasualInterviewPrepController < ApplicationController
    def index
      @interview_preps = current_user.interview_preps.order(updated_at: :desc)
      @sessions = current_user.ai_sessions.casual_interview_prep.recent
    end

    def show
      @ai_session = current_user.ai_sessions.find(params[:id])
      @messages = @ai_session.ai_messages.chronological
    end

    def create
      interview_prep = current_user.interview_preps.find(params[:interview_prep_id]) if params[:interview_prep_id].present?
      service = CasualInterviewPrepService.new(current_user, interview_prep)
      @ai_session = service.start_session

      redirect_to preparation_casual_interview_prep_path(@ai_session)
    end
  end
end
