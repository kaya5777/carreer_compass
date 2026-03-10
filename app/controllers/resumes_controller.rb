class ResumesController < ApplicationController
  def create
    pdf_file = params[:resume][:pdf_file]
    title = pdf_file.present? ? File.basename(pdf_file.original_filename, ".pdf") : "職務経歴書"
    @resume = current_user.resumes.build(title: title, status: :draft)

    if pdf_file.present?
      @resume.pdf_file.attach(pdf_file)
      @resume.raw_content = extract_pdf_text(pdf_file.tempfile)
    end

    if @resume.save
      service = ResumeReviewService.new(current_user, @resume)
      ai_session = service.start_session
      redirect_to preparation_resume_review_path(ai_session)
    else
      redirect_to preparation_resume_review_index_path, alert: @resume.errors.full_messages.join(", ")
    end
  end

  def destroy
    resume = current_user.resumes.find(params[:id])
    resume.destroy
    redirect_to preparation_resume_review_index_path, notice: "職務経歴書を削除しました"
  end

  private

  def extract_pdf_text(tempfile)
    reader = PDF::Reader.new(tempfile.path)
    reader.pages.map(&:text).join("\n").strip
  rescue => e
    Rails.logger.warn "PDF text extraction failed: #{e.message}"
    ""
  end
end
