class PaymentMethods::GoogleOrder < ActiveRecord::Base
  # this isn't a payment method.  it is a model used internally by PaymentMethods::GoogleSubscription.
  
  belongs_to :google_subscription
  composed_of :amount, :class_name => "Money", :mapping => [%w(cents cents), %w(currency currency)]
  
  def financial_order_state=(new_state)
    old_state = financial_order_state
    write_attribute(:financial_order_state, new_state)
    
    if old_state != new_state
      if new_state == "CHARGEABLE"
        frontend = PaymentMethods::GoogleSubscription.frontend
        command = frontend.create_charge_order_command
        command.google_order_number = google_order_number
        command.amount = amount
        command.send_to_google_checkout
      elsif new_state == "CHARGED"
        google_subscription.payment_successful(amount)
      end
    end
  end
end