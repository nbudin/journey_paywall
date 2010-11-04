class PrepublishController < ApplicationController
  require_permission "edit", :class_name => "Questionnaire", :id_param => "questionnaire_id"
  before_filter :get_questionnaire
  helper :subscriptions
  
  def index
    @subscriptions = Subscription.find_all_by_person(logged_in_person)
    @subscriptions << @questionnaire.subscription if @questionnaire.subscription
  end
  
  def set_subscription
    subscr_id = params[:subscription_id] || params[:questionnaire].try(:[], :subscription_id)
    if subscr_id and subscr_id != 'new'
      @subscription = Subscription.find(subscr_id)
      unless @subscription && (@subscription == @questionnaire.subscription || logged_in_person.permitted?(@subscription, "create_questionnaires"))
        redirect_to :action => "index"
        return
      end

      @questionnaire.subscription = @subscription
      if @questionnaire.save
        redirect_to :controller => "publish", :questionnaire_id => @questionnaire, :action => "settings"
        return
      else
        self.index
        render :action => "index"
        return
      end
    end

    @subscription_plans = SubscriptionPlan.find_all_by_allow_public_signup(true)
  end
  
  private
  def get_questionnaire
    @questionnaire = Questionnaire.find(params[:questionnaire_id])
  end
end