require 'rails_helper'

describe Catherine::Admin::CountriesController, :type => :controller do

  let(:country) {FactoryGirl.create(:country)}
  let(:site_admin_role) {FactoryGirl.create(:role, name: "Site Admin")}
  let(:site_admin_user) {site_admin_role && FactoryGirl.create(:site_admin_user)}
  let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
  let(:approved_user) {FactoryGirl.create(:approved_user)}
  
  render_views

  describe "index" do
    before :each do
      country
    end
    describe "Positive Case" do
      it "should list the countries for site admin" do
        session[:id] = site_admin_user.id

        get :index, params: { use_route: 'catherine' }
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).not_to be_empty
        expect(response.body).to include "Manage Countries"
        expect(response.body).to include country.name
      end

      it "should list the countries for super admin user" do
        session[:id] = super_admin_user.id

        get :index, params: { use_route: 'catherine' }
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).not_to be_empty
        expect(response.body).to include "Manage Countries"
        expect(response.body).to include country.name
      end

      it "should refresh the list the countries for site admin" do
        session[:id] = site_admin_user.id

        get :index, params: { use_route: 'catherine' }, xhr: true
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).not_to be_empty
        expect(response.body).to include country.name
      end

      it "should setup all resource controller variables as per the standards" do
        session[:id] = site_admin_user.id

        get :index, params: { use_route: 'catherine' }

        expect(assigns(:countries)).not_to be_empty
        expect(assigns(:r_objects)).not_to be_empty

        expect(assigns(:resource_options)[:page_title]).to match("Countries")
        expect(assigns(:resource_options)[:current_nav]).to match("admin/countries")
        expect(assigns(:resource_options)[:js_view_path]).to match("/kuppayam/workflows/parrot")
        expect(assigns(:resource_options)[:view_path]).to match("/catherine/admin/countries")
        expect(assigns(:resource_options)[:collection_name]).to match("countries")
        expect(assigns(:resource_options)[:item_name]).to match("country")
        expect(assigns(:resource_options)[:class]).to be(Country)
        expect(assigns(:resource_options)[:layout]).to match(:table)
        expect(assigns(:resource_options)[:show_modal_after_create]).to be_truthy
        expect(assigns(:resource_options)[:show_modal_after_update]).to be_truthy

        expect(assigns(:title)).to match("Countries")

        expect(assigns(:breadcrumbs)[:heading]).to match("Manage Countries")
        expect(assigns(:breadcrumbs)[:description]).to match("Listing all Countries")
        links = [ 
                  {:name=>"Home", :link=>"/admin/dashboard?locale=en", :icon=>"fa-home"},
                  {:name=>"Manage Countries", :link=>"/admin/countries?locale=en", :icon=>"fa-calendar", :active=>true}
                ]
        expect(assigns(:breadcrumbs)[:links]).to match_array(links)

        expect(assigns(:filter_settings)[:string_filters]).not_to be_empty
        expect(assigns(:filter_settings)[:boolean_filters]).to be_empty
        expect(assigns(:filter_settings)[:reference_filters]).to be_empty
        expect(assigns(:filter_settings)[:variable_filters]).to be_empty

        expect(assigns(:filter_ui_settings)).to be_empty
      end
    end

    describe "Negative Case" do
      it "should redirect to sign in page if user is not signed in" do
        get :index, params: { use_route: 'catherine' }

        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(usman.sign_in_path)
      end

      it "should redirect to dashboard page for user who doesn't have access" do
        session[:id] = approved_user.id

        get :index, params: { use_route: 'catherine' }

        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(catherine.user_dashboard_path)
      end
    end
  end

  describe "show" do
    before :each do
      country
    end
    describe "Positive Case" do
      it "should show a country for site admin" do
        session[:id] = site_admin_user.id

        get :show, params: { use_route: 'catherine', id: country.id }, xhr: true

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:_show)
        expect(response.body).not_to be_empty
        expect(response.body).to include country.name
      end

      it "should show a country for super admin user" do
        session[:id] = super_admin_user.id

        get :show, params: { use_route: 'catherine', id: country.id }, xhr: true
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:_show)
        expect(response.body).not_to be_empty
        expect(response.body).to include country.name
      end
    end

    describe "Negative Case" do
      it "should redirect to sign in page if user is not signed in" do
        get :show, params: { use_route: 'catherine', id: country.id }
        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(usman.sign_in_path)
      end

      it "should redirect to dashboard page for user who doesn't have access" do
        session[:id] = approved_user.id

        get :show, params: { use_route: 'catherine', id: country.id }

        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(catherine.user_dashboard_path)
      end
    end
  end

  describe "new" do
    describe "Positive Case" do
      it "should show the country form for site admin" do
        session[:id] = site_admin_user.id

        get :new, params: { use_route: 'catherine'}, xhr: true

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:_form)
        expect(response.body).not_to be_empty
      end

      it "should show a country for super admin user" do
        session[:id] = super_admin_user.id

        get :new, params: { use_route: 'catherine'}, xhr: true
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:_form)
        expect(response.body).not_to be_empty
      end
    end

    describe "Negative Case" do
      it "should redirect to sign in page if user is not signed in" do
        get :new, params: { use_route: 'catherine'}
        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(usman.sign_in_path)

        get :new, params: { use_route: 'catherine'}, xhr: true
        expect(response).to have_http_status(:success)
        expect(response).to render_template("usman/sessions/_sign_in.js.erb")
      end

      it "should redirect to dashboard page for user who doesn't have access" do
        session[:id] = approved_user.id

        get :new, params: { use_route: 'catherine'}
        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(catherine.user_dashboard_path)

        get :new, params: { use_route: 'catherine'}, xhr: true
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "edit" do
    describe "Positive Case" do
      it "should show the country form for site admin" do
        session[:id] = site_admin_user.id

        get :edit, params: { use_route: 'catherine', id: country.id }, xhr: true
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:_form)
        expect(response.body).not_to be_empty
      end

      it "should show a country for super admin user" do
        session[:id] = super_admin_user.id

        get :edit, params: { use_route: 'catherine', id: country.id }, xhr: true
        
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:_form)
        expect(response.body).not_to be_empty
      end
    end
    describe "Negative Case" do
      it "should redirect to sign in page if user is not signed in" do
        get :edit, params: { use_route: 'catherine', id: country.id }
        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(usman.sign_in_path)
      end

      it "should redirect to dashboard page for user who doesn't have access" do
        session[:id] = approved_user.id

        get :edit, params: { use_route: 'catherine', id: country.id }

        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(catherine.user_dashboard_path)
      end
    end
  end

  describe "create" do
    describe "Positive Case" do
      it "should create a new country for the site admin" do
        session[:id] = site_admin_user.id
        
        country_params = FactoryGirl.build(:country).attributes
        expect do
          post :create, params: { use_route: 'catherine', country: country_params }, xhr: true
        end.to change(Country, :count).by(1)
        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty
      end

      it "should create a new country for the super admin user" do
        super_admin_user = FactoryGirl.create(:super_admin_user)
        session[:id] = super_admin_user.id

        country_params = FactoryGirl.build(:country).attributes
        expect do
          post :create, params: { use_route: 'catherine', country: country_params }, xhr: true
        end.to change(Country, :count).by(1)
        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty
      end
    end
    
    describe "Negative Case" do
      it "should show errors for invalid data for the site admin" do
        session[:id] = site_admin_user.id
        
        country_params = FactoryGirl.build(:country).attributes
        country_params["name"] = ""

        expect do
          post :create, params: { use_route: 'catherine', country: country_params }, xhr: true
        end.to change(Country, :count).by(0)
        
        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty
        expect(response.body).to include "You have few errors. They have been highlighted."
      end

      it "should redirect to sign in page if user is not signed in" do
        country_params = FactoryGirl.build(:country).attributes
        session[:id] = nil

        post :create, params: { use_route: 'catherine', country: country_params }

        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(usman.sign_in_path)
      end

      it "should redirect to dashboard page for user who doesn't have access" do
        country_params = FactoryGirl.build(:country).attributes
        session[:id] = approved_user.id

        post :create, params: { use_route: 'catherine', country: country_params }

        expect(response).to have_http_status(302)
        expect(response.redirect_url).to match(catherine.user_dashboard_path)
      end
    end
  end

  describe "update" do
    describe "Positive Case" do
      it "should update the country for the site admin" do
        session[:id] = site_admin_user.id

        country = FactoryGirl.create(:country)
        country_params = country.attributes
        country_params["name"] = "Updated Name"
        put :update, params: { use_route: 'catherine', country: country_params, id: country.id }, xhr: true

        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty

        expect(country.reload.name).to match("Updated Name")
      end

      it "should update the country for the super admin user" do
        super_admin_user = FactoryGirl.create(:super_admin_user)
        session[:id] = super_admin_user.id

        country = FactoryGirl.create(:country)
        country_params = country.attributes
        country_params["name"] = "Updated Name"
        put :update, params: { use_route: 'catherine', country: country_params, id: country.id }, xhr: true

        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty

        expect(country.reload.name).to match("Updated Name")
      end
    end

    describe "Negative Case" do
      it "should show errors for invalid data for the site admin" do
        session[:id] = site_admin_user.id
        
        country = FactoryGirl.create(:country)
        country_params = country.attributes
        country_params["name"] = ""

        expect do
          put :update, params: { use_route: 'catherine', country: country_params, id: country.id }, xhr: true
        end.to change(Country, :count).by(0)
        
        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty
        expect(response.body).to include "You have few errors. They have been highlighted."
      end

      it "should redirect to sign in page if user is not signed in" do
        session[:id] = nil

        country = FactoryGirl.create(:country)
        country_params = country.attributes
        country_params["name"] = "Updated Name"

        put :update, params: { use_route: 'catherine', country: country_params, id: country.id }
        expect(response.status).to eq(302)
        expect(response.redirect_url).to match(usman.sign_in_path)
      end

      it "should redirect to dashboard page for user who doesn't have access" do
        session[:id] = approved_user.id

        country = FactoryGirl.create(:country)
        country_params = country.attributes
        country_params["name"] = "Updated Name"

        put :update, params: { use_route: 'catherine', country: country_params, id: country.id }
        expect(response.status).to eq(302)
        expect(response.redirect_url).to match(catherine.user_dashboard_path)
      end
    end
  end

  describe "destroy" do

    describe "Positive Case" do
      it "should delete the country for the site admin" do
        session[:id] = site_admin_user.id

        country = FactoryGirl.create(:country)
        expect do
          delete :destroy, params: { use_route: 'catherine', id: country.id }, xhr: true
        end.to change(Country, :count).by(-1)

        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty

        expect(Country.exists?(country.id)).to eq(false)
      end

      it "should delete the country for the super admin user" do
        super_admin_user = FactoryGirl.create(:super_admin_user)
        session[:id] = super_admin_user.id

        country = FactoryGirl.create(:country)
        expect do
          delete :destroy, params: { use_route: 'catherine', id: country.id }, xhr: true 
        end.to change(Country, :count).by(-1)

        expect(response).to have_http_status(:success)
        expect(response.body).not_to be_empty

        expect(Country.exists?(country.id)).to eq(false)
      end
    end

    describe "Negative Case" do
      it "should redirect to sign in page if user is not signed in" do
        session[:id] = nil
        country = FactoryGirl.create(:country)
        
        expect do
          delete :destroy, params: { use_route: 'catherine', id: country.id }  
        end.to change(Country, :count).by(0)
        expect(Country.exists?(country.id)).to eq(true)

        expect(response.status).to eq(302)
        expect(response.redirect_url).to match(usman.sign_in_path)
      end

      it "should redirect to dashboard page for user who doesn't have access" do
        session[:id] = approved_user.id

        country = FactoryGirl.create(:country)
        
        expect do
          delete :destroy, params: { use_route: 'catherine', id: country.id }  
        end.to change(Country, :count).by(0)
        expect(Country.exists?(country.id)).to eq(true)

        expect(response.status).to eq(302)
        expect(response.redirect_url).to match(catherine.user_dashboard_path)
      end
    end
  end
  
end
