class SubscriptionPlan < ActiveRecord::Base
  unloadable
  has_many :subscriptions
  composed_of :price, :class_name => "Money", :mapping => [%w(cents cents), %w(currency currency)]
  composed_of :startup_cost, :class_name => "Money", :mapping => [%w(startup_cost_cents cents), %w(startup_cost_currency currency)]

  def free?
    cents == 0
  end
  
  def forever?
    rebill_period == "never"
  end
  
  def price_us_dollars
    price_us_dollars_for(:price, :cents)
  end
  
  def price_us_dollars=(p)
    self.price = Money.us_dollar(p.to_f * 100)
  end
  
  def price_us_dollars_for(field, cents_field=nil)
    money = case cents_field
    when nil
      field
    else
      if self.send(cents_field)
        self.send(field)
      end
    end
    
    if money && money.cents > 0
      sprintf("%.2f", money.cents / 100.0)
    else
      nil
    end
  end
  
  def startup_cost_us_dollars
    price_us_dollars_for(:startup_cost, :startup_cost_cents)
  end
  
  def startup_cost_us_dollars=(p)
    self.startup_cost = Money.us_dollar(p.to_f * 100)
  end
  
  def human_rebill_period
    if rebill_period == "never"
      "billed once"
    else
      rebill_period
    end
  end
    
  def human_price
    hp = ""
    if startup_cost_cents
      hp << "$#{price_us_dollars_for(price + startup_cost)} first "
      hp << case rebill_period
      when "monthly"
        "month"
      when "yearly"
        "year"
      else
        "billing period"
      end
      hp << "<br/>\n+<br/>\n"
    end
    
    hp << "$#{price_us_dollars} #{human_rebill_period}"
    if startup_cost_cents
      hp << " afterwards"
    end
    
    return hp
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
    return date unless grace_period
    
    date + grace_period.days
  end
  
  def questionnaire_specific?
    self.open_questionnaires == 1
  end
end