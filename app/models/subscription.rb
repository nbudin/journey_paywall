class Subscription < ActiveRecord::Base
  unloadable
  acts_as_permissioned :permission_names => [:edit, :create_questionnaires, :destroy]
  belongs_to :subscription_plan
  has_many :questionnaires
  #has_many :people, :through => :permissions, :conditions => "permission is null or permission = 'create_questionnaires'"

  def self.find_all_by_person(person, options={})
    Permission.find(:all, options.update(:conditions => ["permissioned_type = 'Subscription' and person_id = ?", person.id])).collect do |perm|
      perm.permissioned
    end.uniq.compact
  end
  
  def people
    permissions.all(:conditions => ["permission is null or permission = 'create_questionnaires'"]).collect do |perm|
      perm.person
    end.uniq.compact
  end

  def grace_period_ends_at
    if subscription_plan
      subscription_plan.add_grace_period(rebill_at)
    else
      Time.at(0)
    end
  end
  
  def rebill_at
    if subscription_plan
      subscription_plan.add_rebill_period(last_paid_at)
    else
      Time.at(0)
    end
  end
  
  def expired?
    last_paid_at.nil? or rebill_at < Time.new
  end

  def past_grace_period?
    grace_period_ends_at and grace_period_ends_at < Time.new
  end
  
  def currently_unlimited?
    if subscription_plan and subscription_plan.unlimited
      return (subscription_plan.forever? or not past_grace_period?)
    else
      return false
    end
  end
  
  def open_questionnaires
    subscription_plan ? subscription_plan.open_questionnaires : 0
  end
  
  def responses_per_month
    subscription_plan ? subscription_plan.responses_per_month : 0
  end
  
  def sid
    "J#{sprintf '%04d', id}"
  end
  
  def name
    sname = ""
    if people.size == 1
      sname << "#{people.first.name}'s "
    end
    if subscription_plan
      sname << "#{subscription_plan.name}"
    else
      sname << "Expired/cancelled"
    end
    sname << " subscription (#{sid})"
  end
  
  def free?
    subscription_plan and subscription_plan.free?
  end
  
  def forever?
    subscription_plan and subscription_plan.forever?
  end

  def questionnaire_over_limit?(questionnaire)
    if currently_unlimited?
      return false
    else
      limit = open_questionnaires || 0
      others = questionnaires.count(:conditions => ["is_open = ? and id != ?", 
                                                   true, questionnaire.id])
      return others >= limit
    end
  end

  def response_over_limit?(response)
    if currently_unlimited?
      return false
    else
      limit = responses_per_month || 0
      create_time = response.created_at || Time.new
      month_start = create_time.beginning_of_month
      month_end = create_time.end_of_month
      others = Response.count(:conditions => ["subscription_id = ? and responses.created_at between ? and ? " +
                                              "and responses.id in (select response_id from answers)",
                                              id, month_start, month_end],
                              :joins => [:questionnaire])
      return others >= limit
    end
  end
end
