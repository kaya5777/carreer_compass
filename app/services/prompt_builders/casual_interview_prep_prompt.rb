module PromptBuilders
  class CasualInterviewPrepPrompt < BasePromptBuilder
    def build_initial_message
      prep = @options[:interview_prep]
      if prep
        "#{prep.company_name}のカジュアル面談に向けて準備をしたいです。\n\n企業情報: #{prep.company_info}\n求人情報: #{prep.job_posting}"
      else
        "カジュアル面談の準備をしたいです。相手の企業について教えてください。"
      end
    end

    private

    def specific_instructions
      <<~INSTRUCTIONS
        あなたはカジュアル面談対策の専門アドバイザーです。

        役割：
        - カジュアル面談の特徴と通常の面接との違いを説明します
        - 企業への質問リストの作成をサポートします
        - 自己紹介の準備をサポートします
        - カジュアル面談でのマナーやポイントをアドバイスします

        カジュアル面談のポイント：
        1. 選考ではないが、印象は重要
        2. 企業を知る場であると同時に、自分を知ってもらう場
        3. 質問を積極的にすることが好印象
        4. 服装はビジネスカジュアルが無難
        5. 転職理由は前向きな表現で

        #{user_context}
      INSTRUCTIONS
    end
  end
end
