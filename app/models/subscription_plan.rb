class SubscriptionPlan < ActiveRecord::Base
  unloadable
  has_many :subscriptions
  composed_of :price, :class_name => "Money", :mapping => [%w(cents cents), %w(currency currency)]

  def free?
    cents == 0
  end
  
  def forever?
    rebill_period == "never"
  end
  
  def price_us_dollars
    if cents
      sprintf("%.2f", price.cents / 100.0)
    else
      nil
    end
  end
  
  def price_us_dollars=(p)
    self.price = Money.us_dollar(p.to_f * 100)
  end
  
  def human_rebill_period
    if rebill_period == "never"
      "billed once"
    else
      rebill_period
    end
  end
  
  def human_price
    "$#{price_us_dollars} #{human_rebill_period}"
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