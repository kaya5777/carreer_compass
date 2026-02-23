class ResumeReviewService
  include AiConversable

  def initialize(user, resume)
    @user = user
    @resume = resume
    @prompt_builder = PromptBuilders::ResumeReviewPrompt.new(user: user, resume: resume)
  end

  private

  def create_session
    AiSession.create!(
      user: @user,
      sessionable: @resume,
      session_type: :resume_review,
      title: "#{@resume.title} レビュー",
      system_prompt: @prompt_builder.build_system_prompt,
      status: :active
    )
  end

  def build_initial_message
    @prompt_builder.build_initial_message
  end

  def system_prompt
    @prompt_builder.build_system_prompt
  end
end
