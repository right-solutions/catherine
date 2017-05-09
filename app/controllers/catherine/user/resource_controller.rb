module Catherine
	module User
	  class ResourceController < Catherine::User::BaseController

	  	include ResourceHelper

	  	before_action :configure_resource_controller

	    def resource_url(obj)
		    url_for([:user, obj])
		  end

	  end
	end
end
