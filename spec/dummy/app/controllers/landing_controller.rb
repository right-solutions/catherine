class LandingController < Catherine::ApplicationController

	def index
		if @current_user
	  	if @current_user.super_admin? || @current_user.has_role?("Site Admin")
	  		redirect_to catherine.admin_dashboard_url
	  	else
	      redirect_to catherine.user_dashboard_url
	  	end
	  else
	  	redirect_to usman.sign_in_url
	  end
  end

end

