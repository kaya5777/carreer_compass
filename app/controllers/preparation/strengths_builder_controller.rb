module Preparation
  class StrengthsBuilderController < ApplicationController
    before_action :set_session, only: [:show]

    def index
      @sessions = current_user.ai_sessions.strengths_builder.recent
    end

    def show
      @ai_session = current_user.ai_sessions.find(params[:id])
      @messages = @ai_session.ai_messages.chronological
    end

    def create
      resume = current_user.resumes.find(params[:resume_id]) if params[:resume_id].present?
      service = StrengthsBuilderService.new(
        current_user,
        resume,
        target_role: params[:target_role],
        additional_info: params[:additional_info]
      )
      @ai_session = service.start_session

      redirect_to preparation_strengths_builder_path(@ai_session)
    end

    private

    def set_session
      # ai_session is loaded in show action
    end
  end
end
