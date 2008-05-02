ActionController::Routing::Routes.draw do |map|

  map.resources :customers, :has_many => :addresses
  map.resources :users
  map.resources :addresses
  map.resources :invoices, :has_many => :items, :member => {:pdf => :get}

  map.root :controller => :invoices

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
