class DashboardController < ApplicationController
  def show
    @recent_sessions = current_user.ai_sessions.recent.limit(5)
  end
end
