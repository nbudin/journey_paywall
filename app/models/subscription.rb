class Subscription < ActiveRecord::Base
  acts_as_permissioned :permission_names => [:edit, :create_questionnaires, :destroy]
  has_many :questionnaires
  has_many :people, :through => :permissions, :conditions => "permission is null or permission = 'create_questionnaires'"

  def self.find_all_by_person(person)
    Permission.find(:all, :conditions => ["permissioned_type = 'Subscription' and person_id = ?", person.id]).collect do |perm|
      perm.permissioned
    end
  end

  def expired?
    expires_at < Time.new
  end

  def past_grace_period?
    expires_at < (Time.new + 30.days)
  end

  def currently_unlimited?
    if unlimited
      return (expires_at.nil? or not past_grace_period?)
    else
      return false
    end
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
