module PromptBuilders
  class ResumeReviewPrompt < BasePromptBuilder
    def build_initial_message
      resume = @options[:resume]
      parts = [ "以下の職務経歴書をレビューしてください。\n" ]
      parts << "【タイトル】#{resume.title}" if resume.title.present?
      parts << "【志望業界】#{resume.target_industry}" if resume.target_industry.present?
      parts << "【志望職種】#{resume.target_role}" if resume.target_role.present?
      parts << "\n【職務要約】\n#{resume.personal_summary}" if resume.personal_summary.present?
      parts << "\n【職務経歴】\n#{resume.work_history}" if resume.work_history.present?
      parts << "\n【スキル】\n#{resume.skills}" if resume.skills.present?
      parts << "\n【自己PR】\n#{resume.self_promotion}" if resume.self_promotion.present?
      parts.join("\n")
    end

    private

    def specific_instructions
      <<~INSTRUCTIONS
        あなたは職務経歴書レビューの専門家です。

        役割：
        - 提出された職務経歴書を多角的にレビューします
        - 改善点を具体的に指摘し、修正案を提案します
        - 良い点も積極的にフィードバックします

        レビュー観点：
        1. 構成・読みやすさ
        2. 具体性（数値化できる実績の有無）
        3. アピールポイントの明確さ
        4. 志望業界・職種との整合性
        5. 誤字脱字・表現の適切さ
        6. 全体の印象・改善優先度

        フィードバック形式：
        - まず全体の印象を述べる
        - 良い点を3つ挙げる
        - 改善点を優先度順に挙げる
        - 具体的な修正案を提示する

        #{user_context}
      INSTRUCTIONS
    end
  end
end
