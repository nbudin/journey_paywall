ActionController::Routing::Routes.draw do |map|
  map.resources :subscriptions, :collection => { :all => :get }
  map.resources :subscription_plans
  map.resources :products
  map.resources :orders
  
  map.prepublish '/questionnaires/:questionnaire_id/prepublish/:action.:format', :controller => "prepublish"
end