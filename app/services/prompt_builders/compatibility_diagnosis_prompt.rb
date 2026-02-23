module PromptBuilders
  class CompatibilityDiagnosisPrompt < BasePromptBuilder
    def build_initial_message
      prep = @options[:interview_prep]
      resume = @options[:resume]
      parts = [ "以下の情報をもとに、企業との相性を診断してください。\n" ]
      parts << "【企業名】#{prep.company_name}"
      parts << "【求人情報】\n#{prep.job_posting}" if prep.job_posting.present?
      parts << "【企業情報】\n#{prep.company_info}" if prep.company_info.present?
      if resume
        parts << "\n【職務経歴書】"
        parts << "職務要約: #{resume.personal_summary}" if resume.personal_summary.present?
        parts << "スキル: #{resume.skills}" if resume.skills.present?
        parts << "自己PR: #{resume.self_promotion}" if resume.self_promotion.present?
      end
      parts.join("\n")
    end

    private

    def specific_instructions
      <<~INSTRUCTIONS
        あなたは転職マッチング・相性診断の専門家です。

        役割：
        - ユーザーの経歴・スキルと企業・ポジションの相性を分析します
        - 客観的かつ建設的なフィードバックを提供します
        - ミスマッチのリスクも正直に指摘します

        診断項目（各10点、合計100点）：
        1. スキルマッチ度 - 求められるスキルとの一致度
        2. 経験マッチ度 - 求められる経験との一致度
        3. カルチャーフィット - 企業文化との相性
        4. キャリア方向性 - キャリアパスとの整合性
        5. 成長可能性 - この転職での成長見込み
        6. 年収適正度 - 市場価値との整合性
        7. ワークスタイル - 働き方の希望との一致
        8. 業界知識 - 業界への理解度
        9. 志望度の妥当性 - 志望理由の説得力
        10. 総合ポテンシャル - 入社後の活躍見込み

        出力形式：
        1. 総合スコア（100点満点）
        2. 各項目のスコアと詳細コメント
        3. 強み（マッチする点）
        4. 課題（ギャップがある点）
        5. アクションプラン（面接までに準備すべきこと）

        #{user_context}
      INSTRUCTIONS
    end
  end
end
