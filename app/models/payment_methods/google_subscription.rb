class PaymentMethods::GoogleSubscription < ActiveRecord::Base
  include PaymentMethod
  
  has_many :google_orders
    
  def self.merchant_credentials_match?(merchant_id, merchant_key)
    conf = JourneyPaywall.configuration['google']

    if (conf['merchant_id'].to_s == merchant_id.to_s) and (conf['merchant_key'].to_s == merchant_key.to_s)
      return true
    else
      return false
    end
  end
  
  class TaxTableFactory
    def effective_tax_tables_at(time)
      nil
    end
  end
  
  @@tax_table_factory = TaxTableFactory.new
  
  def self.frontend
    conf = JourneyPaywall.configuration['google']
    frontend = Google4R::Checkout::Frontend.new(
      :merchant_id => conf['merchant_id'],
      :merchant_key => conf['merchant_key'],
      :use_sandbox => conf['use_sandbox']
    )
    frontend.tax_table_factory = @@tax_table_factory
    
    return frontend
  end
  
  def initiate(message=nil)
    checkout_cmd = create_google_checkout_cmd(self.class.frontend, message)
    
    if checkout_cmd
      response = checkout_cmd.send_to_google_checkout
      return response.redirect_url
    end
  end
  
  protected
  
  def request_payment_inner(amount)
    recur_cmd = self.class.frontend.create_create_order_recurrence_request_command
    
    recur_cmd.google_order_number = google_order_number
    recur_cmd.shopping_cart.create_item do |item|
      item.name = "#{subscription.name} payment"
      item.unit_price = amount
      item.quantity = 1
    end
    
    response = recur_cmd.send_to_google_checkout
    google_orders.create :google_order_number => response.new_google_order_number
  end
  
  def create_google_checkout_cmd(frontend, message=nil)
    checkout_cmd = frontend.create_checkout_command
    
    checkout_cmd.shopping_cart.create_item do |item|
      item.name = subscription.name
      item.quantity = 1
      item.private_data = { :product => "journey", 
                            :subscription_id => subscription.id, 
                            :plan_id => subscription.subscription_plan.id }
      
      if subscription.forever?
        item.unit_price = subscription.subscription_plan.price
      else
        item.unit_price = Money.new(0, "USD")
      
        item.create_subscription do |item_subscription|
          item_subscription.type = "merchant"
          case subscription.subscription_plan.rebill_period
            when "monthly" then item_subscription.period = "MONTHLY"
            when "yearly" then item_subscription.period = "YEARLY"
          end
          item_subscription.start_date = subscription.rebill_at
          
          item_subscription.add_payment do |payment|
            payment.maximum_charge = subscription.subscription_plan.price
          end
        end
      end
      
      if message
        item.create_digital_content do |content|
          content.display_disposition = "OPTIMISTIC"
          content.description = message
        end
      end
    end
    
    return checkout_cmd
  end
end