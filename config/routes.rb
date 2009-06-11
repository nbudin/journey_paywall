ActionController::Routing::Routes.draw do |map|
  map.resources :subscriptions, :collection => { :all => :get }
  map.resources :subscription_plans
end