class Product < ActiveRecord::Base
  unloadable
  composed_of :price, :class_name => "Money", :mapping => [%w(cents cents), %w(currency currency_as_string)]
  composed_of :extra_time_price, :class_name => "Money", :mapping => [%w(extra_time_price_cents cents), %w(extra_time_price_currency currency_as_string)]
  composed_of :extra_responses_price, :class_name => "Money", :mapping => [%w(extra_responses_price_cents cents), %w(extra_responses_price_currency currency_as_string)]
  
  has_many :orders
  
  def build_order(options={})
    orders.new(options.merge(:price => price, :days => days, :responses => responses))
  end
  
  def build_supplemental_order(time_quantity, responses_quantity, options={})
    price = extra_time_price * time_quantity + extra_responses_price * responses_quantity
    
    orders.new(options.merge(:price => price, 
        :days => time_quantity * extra_time_days, 
        :responses => responses_quantity * extra_responses_quantity,
        :supplemental => true))
  end
  
  def supplemental_time_needed(questionnaire)
    (Order.supplemental_days_needed(questionnaire).to_f / extra_time_days).ceil
  end
  
  def supplemental_response_orders_needed(questionnaire)
    (Order.supplemental_responses_needed(questionnaire).to_f / extra_responses_quantity).ceil
  end
  
  def build_needed_supplemental_order(questionnaire, options={})
    order = build_supplemental_order(
      supplemental_time_needed(questionnaire),
      supplemental_response_orders_needed(questionnaire),
      options.merge(:questionnaire => questionnaire)
    )
    
    return order if order.days > 0 || order.responses > 0
  end
end