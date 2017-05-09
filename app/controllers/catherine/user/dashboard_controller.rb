module Catherine
  module User
    class DashboardController < Catherine::User::BaseController

    	layout 'kuppayam/user'
        
      before_action :require_user

    	def index
      end

      private

      def set_default_title
      	set_title("Dashboard | User")
      end

      def breadcrumbs_configuration
	      {
	        heading: "Dashboard",
	        description: current_user.try(:name),
	        links: []
	      }
	    end

	    def set_navs
	      set_nav("user/dashboard")
	    end

    end
  end
end