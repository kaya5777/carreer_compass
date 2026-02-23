module PromptBuilders
  class QuestionGeneratorPrompt < BasePromptBuilder
    def build_initial_message
      prep = @options[:interview_prep]
      parts = [ "以下の企業・ポジションの面接想定質問を作成してください。\n" ]
      parts << "企業名: #{prep.company_name}"
      parts << "面接タイプ: #{prep.interview_type_i18n}"
      parts << "求人情報:\n#{prep.job_posting}" if prep.job_posting.present?
      parts << "企業情報:\n#{prep.company_info}" if prep.company_info.present?
      parts.join("\n")
    end

    private

    def specific_instructions
      <<~INSTRUCTIONS
        あなたは面接想定質問作成の専門家です。

        役割：
        - 企業・ポジション・面接タイプに応じた想定質問を生成します
        - 各質問に回答のポイントと模範解答例を提供します
        - 質問の難易度とカテゴリを明示します

        質問カテゴリ：
        - 自己紹介・経歴
        - 志望動機
        - 経験・実績
        - 技術・スキル
        - 行動特性（STAR法）
        - 企業固有の質問
        - キャリアプラン

        出力形式（各質問）：
        【質問】具体的な質問文
        【カテゴリ】上記のいずれか
        【難易度】易しい/普通/難しい
        【回答のポイント】簡潔なアドバイス
        【模範解答例】具体的な回答例

        #{user_context}
      INSTRUCTIONS
    end
  end
end
