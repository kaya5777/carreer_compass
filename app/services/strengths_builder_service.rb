class StrengthsBuilderService
  include AiConversable

  def initialize(user, resume = nil, target_role: nil, additional_info: nil)
    @user = user
    @resume = resume
    @target_role = target_role
    @prompt_builder = PromptBuilders::StrengthsBuilderPrompt.new(
      user: user,
      resume: resume,
      target_role: target_role,
      additional_info: additional_info
    )
  end

  private

  def create_session
    AiSession.create!(
      user: @user,
      sessionable: @resume,
      session_type: :strengths_builder,
      title: build_session_title,
      system_prompt: @prompt_builder.build_system_prompt,
      status: :active
    )
  end

  def build_session_title
    date = Time.current.strftime("%m/%d %H:%M")
    @target_role.present? ? "#{@target_role}の自己PR #{date}" : "自己PR・強み作成 #{date}"
  end

  def build_initial_message
    @prompt_builder.build_initial_message
  end

  def system_prompt
    @prompt_builder.build_system_prompt
  end
end
