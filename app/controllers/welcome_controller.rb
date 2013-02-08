class WelcomeController < ApplicationController
  layout 'public'

  def index
    if user_logged_in
      if current_user.user_ok?
        redirect_to dashboard_url
      else
        redirect_to validate_users_url
      end
    end
  end
end
