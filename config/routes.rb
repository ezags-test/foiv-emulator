FoivEmulator::Application.routes.draw do
  mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'
  resources :requests

  root to: 'requests#new'
end
