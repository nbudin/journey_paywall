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
      format.js do
        render :update do |page|
          page['new_subscription'].replace(render :partial => "new", :layout => false)
        end
      end
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
      @person = logged_in_person
    elsif params[:person]
      create_account_and_person()
      if @person
        session[:person] = @person
      end
    end
    
    if @person
      @plan = SubscriptionPlan.find(params[:subscription][:subscription_plan_id])
      unless @plan.allow_public_signup
        access_denied("Sorry, but that plan is not publicly accessible.  If you want to sign up for it, please contact support.")
      end
      
      if @plan.free?
        redirect_to subscriptions_url
      else
        @other_subscriptions = Subscription.find_all_by_person(@person, :conditions => "last_paid_at is not null")
        if @other_subscriptions.size == 0
          # give them a free trial
          @last_paid_at = Time.new.beginning_of_day + 1.day
        end
        
        @subscription = Subscription.new :subscription_plan => @plan, :last_paid_at => @last_paid_at
        
        if params[:payment_method] == "google"
          @subscription.payment_method = PaymentMethods::GoogleSubscription.create
          @subscription.save
          @subscription.grant(@person)
      
          redirect_url = @subscription.payment_method.initiate(
            :message => "Thanks for choosing Journey!  Your subscription is being set up.  "+
            "Feel free to <a href=\"#{url_for "/"}\">log on</a> and try it out!",
            :bill_now => @last_paid_at.nil?
          )
        
          redirect_to (redirect_url or subscriptions_url)
        end
      end
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