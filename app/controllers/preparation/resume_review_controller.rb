module Preparation
  class ResumeReviewController < ApplicationController
    def index
      @resumes = current_user.resumes.order(updated_at: :desc)
      @sessions = current_user.ai_sessions.resume_review.recent
    end

    def show
      @ai_session = current_user.ai_sessions.find(params[:id])
      @messages = @ai_session.ai_messages.chronological
    end

    def create
      resume = current_user.resumes.find(params[:resume_id])
      service = ResumeReviewService.new(current_user, resume)
      @ai_session = service.start_session

      redirect_to preparation_resume_review_path(@ai_session)
    end
  end
end
