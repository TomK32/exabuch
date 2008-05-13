ActionController::Routing::Routes.draw do |map|

  map.resources :customers, :member => {:confirm_destroy => :get} do |customer|
    customer.resources :addresses, :invoices, :member => {:confirm_destroy => :get}
  end
  map.resources :users, :has_many => :addresses
  map.resources :addresses, :member => {:confirm_destroy => :get}
  map.resources :invoices, :has_many => :items, :member => {:confirm_destroy => :get}, :has_one => :customer
  map.resources :items

  map.root :controller => 'invoices'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
