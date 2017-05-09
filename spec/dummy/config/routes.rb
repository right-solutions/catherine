Rails.application.routes.draw do
  mount Catherine::Engine => "/"
  get   '/landing', to: "landing#index",  as: :user_landing
  root 'usman/sessions#sign_in'
end
