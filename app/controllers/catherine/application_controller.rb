module Catherine
  class ApplicationController < Kuppayam::BaseController
    
    include Usman::AuthenticationHelper

    before_action :current_user

    def set_default_title
	    set_title("Catherine - Merchandise Application")
	  end

	  def default_redirect_url_after_sign_in
      if @current_user.super_admin? || @current_user.has_role?("Site Admin")
        catherine.admin_dashboard_url
      else
        catherine.user_dashboard_url
      end
    end

  end
end
