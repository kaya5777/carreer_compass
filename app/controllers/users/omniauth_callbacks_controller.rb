class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
  rescue => e
    Rails.logger.error "OmniAuth error: #{e.message}"
    redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
  end

  def failure
    redirect_to new_user_session_path, alert: "Googleログインに失敗しました"
  end
end
