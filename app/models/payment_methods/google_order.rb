class PaymentMethods::GoogleOrder < ActiveRecord::Base
  # this isn't a payment method.  it is a model used internally by PaymentMethods::GoogleSubscription.
  
  belongs_to :google_subscription
end