class SubscriptionPlan < ActiveRecord::Base
  has_many :subscriptions
  
  def free?
    price == 0
  end
  
  def forever?
    rebill_period == "never"
  end
  
  def add_rebill_period(date)
    if rebill_period == "monthly"
      date + 1.month
    elsif rebill_period == "yearly"
      date + 1.year
    elsif forever?
      nil
    end
  end
  
  def add_grace_period(date)
    date + grace_period.days
  end
end