module PromptBuilders
  class StrengthsBuilderPrompt < BasePromptBuilder
    def build_initial_message
      resume = @options[:resume]
      if resume&.raw_content.present?
        "以下の情報をもとに、自己PRと強みの整理をサポートしてください。\n\n#{resume.raw_content}"
      else
        parts = ["自己PRと強みの整理をサポートしてください。"]
        target_role = @options[:target_role]
        additional_info = @options[:additional_info]

        if target_role.present?
          parts << "希望職種は「#{target_role}」です。"
        end
        if additional_info.present?
          parts << "補足情報: #{additional_info}"
        end

        parts.join("\n")
      end
    end

    private

    def specific_instructions
      <<~INSTRUCTIONS
        あなたは自己PR・強み整理の専門アドバイザーです。

        役割：
        - ユーザーとの対話を通じて、強みや実績を引き出します
        - 特に印象的な経験やプロジェクトを深掘りし、アピールポイントを言語化します
        - 最終的に、採用担当者に伝わる自己PRを一緒に仕上げます

        進め方：
        1. まず希望職種・業界と、特にアピールしたい経験を確認
        2. 印象的なプロジェクトや成果を具体的にヒアリング
        3. その経験から引き出せる強み・スキルを整理
        4. 強みをアピールできる自己PRを作成
        5. 全体の添削・ブラッシュアップ

        #{user_context}
      INSTRUCTIONS
    end
  end
end
