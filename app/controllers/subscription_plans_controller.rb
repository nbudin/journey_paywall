class SubscriptionPlansController < ApplicationController
  unloadable
  require_login

  before_filter :check_subscription_admin
  
  def index
    @subscription_plans = SubscriptionPlan.all
  end
  
  def new
    @subscription_plan = SubscriptionPlan.new
  end
  
  def edit
    @subscription_plan = SubscriptionPlan.find(params[:id])
  end
  
  def update
    @plan = SubscriptionPlan.find(params[:id])
    
    respond_to do |format|
      if @plan.update_attributes(params[:subscription_plan])
        format.html { redirect_to subscription_plans_url }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def create
    @plan = SubscriptionPlan.new(params[:subscription_plan])

    respond_to do |format|
      if @plan.save
        format.html { redirect_to subscription_plans_url }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @plan = SubscriptionPlan.find(params[:id])
    if params[:migrate_subscriptions_to]
      @newplan = SubscriptionPlan.find(params[:migrate_subscriptions_to])
      @plan.subscriptions.each do |s|
        s.subscription_plan = @newplan
        s.save
      end
      @plan.reload
    end
    
    if @plan.subscriptions.size == 0
      @plan.destroy
      redirect_to subscription_plans_url
    else
      @possible_plans = SubscriptionPlan.all(:conditions => "id != #{@plan.id}")
    end
  end

  private
  def check_subscription_admin
    unless logged_in_person.permitted?("edit", SubscriptionPlan)
      access_denied "Sorry, only subscription plan administrators are allowed to view that page."
    end
  end
end