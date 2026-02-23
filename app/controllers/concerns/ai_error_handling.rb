module AiErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from GeminiClient::ApiError, with: :handle_ai_error
    rescue_from GeminiClient::RateLimitError, with: :handle_rate_limit_error
  end

  private

  def handle_ai_error(exception)
    Rails.logger.error("AI API Error: #{exception.message}")
    respond_to do |format|
      format.html { redirect_back fallback_location: dashboard_path, alert: "AI機能でエラーが発生しました。しばらくしてから再度お試しください。" }
      format.turbo_stream { render_ai_error("AI機能でエラーが発生しました。しばらくしてから再度お試しください。") }
    end
  end

  def handle_rate_limit_error(exception)
    Rails.logger.warn("AI Rate Limit: #{exception.message}")
    respond_to do |format|
      format.html { redirect_back fallback_location: dashboard_path, alert: "リクエストが多すぎます。しばらくしてから再度お試しください。" }
      format.turbo_stream { render_ai_error("リクエストが多すぎます。しばらくしてから再度お試しください。") }
    end
  end

  def render_ai_error(message)
    render turbo_stream: turbo_stream.append("messages", partial: "shared/ai_error", locals: { message: message })
  end
end
