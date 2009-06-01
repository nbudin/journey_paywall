class Subscription < ActiveRecord::Base
  acts_as_permissioned :permission_names => [:edit, :create_questionnaires, :destroy]
  has_many :questionnaires
  has_many :people, :through => :permissions, :conditions => "permission is null or permission = 'create_questionnaires'"

  def self.find_all_by_person(person)
    Permission.find_all(:conditions => ["permissioned_type = 'Subscription' and person_id = ?", person.id]).collect do |perm|
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
      others = Questionnaire.count(:conditions => ["owner_id = ? and is_open = ? and id != ?", 
                                                   person.id, true, questionnaire.id])
      return others >= open_questionnaires
    end
  end

  def response_over_limit?(response)
    if currently_unlimited?
      return false
    else
      create_time = response.created_at || Time.new
      month_start = create_time.beginning_of_month
      month_end = create_time.end_of_month
      others = Response.count(:conditions => ["owner_id = ? and responses.created_at between ? and ? " +
                                              "and responses.id in (select response_id from answers)",
                                              person.id, month_start, month_end],
                              :joins => [:questionnaire])
      return others >= responses_per_month
    end
  end
end
