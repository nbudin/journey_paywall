class SubscriptionsController < ApplicationController
  unloadable
  require_login :except => ['index', 'create', 'new']
  
  before_filter :check_subscription_admin, :only => ['all']
  before_filter :get_plans
  rest_permissions
  
  def index
    if logged_in?
      @my_subscriptions = Subscription.find_all_by_person(logged_in_person)
    else
      @my_subscriptions = []
    end
  end
  
  def new
    respond_to do |format|
      format.html { render :partial => "new", :layout => false }
    end
  end
  
  def all
    cond_sql = []
    conds = []
    
    unless params[:person].blank?
      likeperson = "%#{params[:person]}%"
      people = Person.all(:conditions => ["firstname like ? or lastname like ?", likeperson, likeperson])
      
      if people.empty?
        cond_sql.push("1 = 0")
      else
        subscrs = Subscription.all(:conditions => "permissions.person_id in (#{people.collect {|p| p.id}.join(",")})", 
          :joins => [:permissions]).uniq.compact
          
        if subscrs.empty?
          cond_sql.push("1 = 0")
        else
          cond_sql.push("id in (#{subscrs.collect {|s| s.id}.join(',')})")
        end
      end
    end
    
    unless params[:subscription_plan_id].blank?
      cond_sql.push("subscription_plan_id = ?")
      conds.push(params[:subscription_plan_id])    
    end
    
    @subscriptions = Subscription.paginate(:page => params[:page], :order => 'id',
      :include => ['questionnaires', 'permissions', 'subscription_plan'],
      :conditions => [cond_sql.join(" and ")] + conds,
      :per_page => 4)
      
    respond_to do |format|
      format.html
      format.js do
        render :update do |page| 
          page.replace 'subscription_list', :partial => 'paged_results'
        end
      end
    end
  end
  
  def create
    if logged_in?
      
    elsif params[:person]
      
    end
  end
  
  private
  def check_subscription_admin
    unless logged_in_person.permitted?("edit", Subscription)
      access_denied "Sorry, only subscription administrators are allowed to view that page."
    end
  end
  
  def get_plans
    @plans = SubscriptionPlan.find_all_by_allow_public_signup(true)
  end
end