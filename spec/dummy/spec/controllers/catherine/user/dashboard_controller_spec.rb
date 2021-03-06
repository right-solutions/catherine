require 'rails_helper'

describe Catherine::User::DashboardController, :type => :controller do

  let(:site_admin_role) {FactoryGirl.create(:role, name: "Site Admin")}
  let(:site_admin_user) {site_admin_role && FactoryGirl.create(:site_admin_user)}
  let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
  let(:approved_user) {FactoryGirl.create(:approved_user)}
  
  render_views

  describe "index" do
    describe "Positive Case" do
      it "should show dashboard for site admin" do
        site_admin_role = FactoryGirl.create(:role, name: "Site Admin")
        site_admin_user = FactoryGirl.create(:site_admin_user)
        session[:id] = site_admin_user.id

        get :index, params: { use_route: 'catherine' }
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).not_to be_empty
        expect(response.body).to include "Dashboard"
      end

      it "should show dashboard for super admin user" do
        super_admin_user = FactoryGirl.create(:super_admin_user)
        session[:id] = super_admin_user.id

        get :index, params: { use_route: 'catherine' }
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).not_to be_empty
        expect(response.body).to include "Dashboard"
      end

      it "should show dashboard for normal user" do
        approved_user = FactoryGirl.create(:approved_user)
        session[:id] = approved_user.id

        get :index, params: { use_route: 'catherine' }
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).not_to be_empty
        expect(response.body).to include "Dashboard"
      end
    end

    describe "Negative Case" do
      it "should redirect to sign in page if user is not signed in" do
        get :index, params: { use_route: 'catherine' }

        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(usman.sign_in_path)
      end
    end
  end
  
end
