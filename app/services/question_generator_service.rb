class QuestionGeneratorService
  include AiConversable

  def initialize(user, company_name: nil, position: nil, interview_type: nil, additional_info: nil)
    @user = user
    @company_name = company_name
    @position = position
    @interview_type = interview_type
    @additional_info = additional_info
    @prompt_builder = PromptBuilders::QuestionGeneratorPrompt.new(
      user: user,
      company_name: company_name,
      position: position,
      interview_type: interview_type,
      additional_info: additional_info
    )
  end

  private

  def create_session
    AiSession.create!(
      user: @user,
      session_type: :question_generator,
      title: build_session_title,
      system_prompt: @prompt_builder.build_system_prompt,
      status: :active
    )
  end

  def build_session_title
    date = Time.current.strftime("%m/%d %H:%M")
    parts = []
    parts << @company_name if @company_name.present?
    parts << @position if @position.present?
    parts.any? ? "#{parts.join(' ')} 想定質問 #{date}" : "想定質問作成 #{date}"
  end

  def build_initial_message
    @prompt_builder.build_initial_message
  end

  def system_prompt
    @prompt_builder.build_system_prompt
  end
end
