FoivEmulator::Application.routes.draw do
  mount RailsAdmin::Engine => '/rails_admin', :as => 'rails_admin'
  root to: 'requests#index'
end
