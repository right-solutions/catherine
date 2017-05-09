module Catherine
  module Admin
    class DashboardController < Catherine::Admin::BaseController

    	def index
      end

      private

      def set_default_title
      	set_title("Dashboard | Admin")
      end

      def breadcrumbs_configuration
	      {
	        heading: "Dashboard",
	        description: nil,
	        links: []
	      }
	    end

	    def set_navs
	      set_nav("user/dashboard")
	    end

    end
  end
end