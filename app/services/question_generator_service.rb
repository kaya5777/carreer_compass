class QuestionGeneratorService
  include AiConversable

  def initialize(user, interview_prep)
    @user = user
    @interview_prep = interview_prep
    @prompt_builder = PromptBuilders::QuestionGeneratorPrompt.new(user: user, interview_prep: interview_prep)
  end

  private

  def create_session
    AiSession.create!(
      user: @user,
      sessionable: @interview_prep,
      session_type: :question_generator,
      title: "#{@interview_prep.company_name} 想定質問",
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
