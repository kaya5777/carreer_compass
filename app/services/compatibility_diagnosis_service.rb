class CompatibilityDiagnosisService
  include AiConversable

  def initialize(user, interview_prep, resume = nil)
    @user = user
    @interview_prep = interview_prep
    @resume = resume
    @prompt_builder = PromptBuilders::CompatibilityDiagnosisPrompt.new(
      user: user,
      interview_prep: interview_prep,
      resume: resume
    )
  end

  private

  def create_session
    AiSession.create!(
      user: @user,
      sessionable: @interview_prep,
      session_type: :compatibility_diagnosis,
      title: "#{@interview_prep.company_name} 相性診断",
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
