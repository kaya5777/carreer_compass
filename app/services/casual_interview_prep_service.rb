class CasualInterviewPrepService
  include AiConversable

  def initialize(user, interview_prep = nil)
    @user = user
    @interview_prep = interview_prep
    @prompt_builder = PromptBuilders::CasualInterviewPrepPrompt.new(user: user, interview_prep: interview_prep)
  end

  private

  def create_session
    AiSession.create!(
      user: @user,
      sessionable: @interview_prep,
      session_type: :casual_interview_prep,
      title: @interview_prep ? "#{@interview_prep.company_name} カジュアル面談対策" : "カジュアル面談対策",
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
