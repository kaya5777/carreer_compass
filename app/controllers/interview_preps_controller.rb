class InterviewPrepsController < ApplicationController
  def create
    @interview_prep = current_user.interview_preps.build(interview_prep_params)
    @interview_prep.interview_type = :casual
    @interview_prep.status = :draft

    if @interview_prep.save
      service = CasualInterviewPrepService.new(current_user, @interview_prep)
      ai_session = service.start_session
      redirect_to preparation_casual_interview_prep_path(ai_session)
    else
      redirect_to preparation_casual_interview_prep_index_path, alert: @interview_prep.errors.full_messages.join(", ")
    end
  end

  def destroy
    interview_prep = current_user.interview_preps.find(params[:id])
    interview_prep.destroy
    redirect_back fallback_location: preparation_casual_interview_prep_index_path, notice: "企業を削除しました"
  end

  private

  def interview_prep_params
    params.require(:interview_prep).permit(:company_name, :job_posting, :company_info)
  end
end
