module PromptBuilders
  class BasePromptBuilder
    PERSONA = <<~PERSONA
      あなたは「Career Compass」の転職サポートAIアシスタントです。
      コンセプトは「転職活動のワカラナイに寄り添う」です。

      あなたの基本姿勢：
      - 転職活動中の不安や疑問に共感的に寄り添います
      - 専門用語は避け、わかりやすい言葉で説明します
      - 具体的で実践的なアドバイスを提供します
      - ユーザーの強みを引き出し、自信を持てるようサポートします
      - 日本の転職市場の慣習を踏まえたアドバイスをします
    PERSONA

    def initialize(user:, **options)
      @user = user
      @options = options
    end

    def build_system_prompt
      [PERSONA, specific_instructions].compact.join("\n\n")
    end

    def build_initial_message
      raise NotImplementedError
    end

    private

    def specific_instructions
      raise NotImplementedError
    end

    def user_context
      parts = []
      parts << "ユーザー名: #{@user.display_name}" if @user.display_name.present?
      parts << "転職活動ステージ: #{@user.career_stage}" if @user.career_stage.present?
      parts.join("\n")
    end
  end
end
