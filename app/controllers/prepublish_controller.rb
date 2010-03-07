class PrepublishController < ApplicationController
  require_permission "edit", :class_name => "Questionnaire", :id_param => "questionnaire_id"
  before_filter :get_questionnaire
  helper :subscriptions
  
  def index
    @subscriptions = Subscription.find_all_by_person(logged_in_person)
  end
  
  def set_subscription
    @subscription_plans = SubscriptionPlan.find_all_by_allow_public_signup(true)
  end
  
  private
  def get_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
  end
end