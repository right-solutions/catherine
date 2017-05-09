Catherine::Engine.routes.draw do

	namespace :admin do

    get   '/dashboard',         to: "dashboard#index",  as:   :dashboard

    # Admin Routes
    resources :countries

  end

  namespace :user do

    get   '/dashboard',         to: "dashboard#index",  as:   :dashboard

  end

  mount Usman::Engine => "/"

end
