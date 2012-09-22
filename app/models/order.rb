class Order < ActiveRecord::Base
  unloadable
  
  belongs_to :product
  belongs_to :questionnaire
  belongs_to :payment_method, :polymorphic => true
  
  composed_of :price, :class_name => "Money", :mapping => [%w(cents cents), %w(currency currency_as_string)]
  
  named_scope :paid, lambda { { :conditions => [ "paid_at IS NOT NULL AND paid_at <= ?", Time.now ] } }

  def self.total_days(scope)
    scope.sum(:days)
  end
  
  def self.total_responses(scope)
    scope.sum(:responses)
  end
  
  def self.days_end_at(scope)
    scope.minimum(:paid_at) + total_days(scope).days
  end
  
  def self.supplemental_responses_needed(questionnaire)
    needed = questionnaire.submitted_responses.count - total_responses(questionnaire.orders.paid)
    needed = 0 if needed < 0
    needed
  end
  
  def self.supplemental_days_needed(questionnaire)
    effective_date = (questionnaire.closes_at || Date.today).to_date
    needed = effective_date - days_end_at(questionnaire.orders.paid).to_date
    needed = 0 if needed < 0
    needed
  end
end