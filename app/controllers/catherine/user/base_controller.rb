module Catherine
  module User
    class BaseController < ApplicationController
      
      layout 'kuppayam/user'
      
      before_action :require_user
      
      private

      def set_default_title
        set_title("Dashboard | User")
      end
      
    end	
  end
end
