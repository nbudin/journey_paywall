class SubscriptionsController < ApplicationController
  unloadable
  require_login
  
  def index
    @my_subscriptions = Subscription.find_all_by_person(logged_in_person)
    @other_subscriptions = Subscription.all.select do |subscr| 
      (not @my_subscriptions.include?(subscr)) and logged_in_person.permitted?(subscr, "edit") 
    end
  end
end