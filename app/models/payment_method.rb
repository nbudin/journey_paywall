module PaymentMethod
  def PaymentMethod.included(c)
    c.class_eval do
      has_one :subscription, :as => :payment_method
      
      def initiate(message=nil)
        raise "This is an abstract method."
      end
      
      def request_payment(new_expiry_date, amount=nil)
        request_payment_inner(new_expiry_date, amount || subscription.subscription_plan.price)
      end
      
      protected
      
      def request_payment_inner(new_expiry_date, amount)
        raise "This is an abstract method."
      end
      
      def payment_successful(new_expiry_date, amount)
        subscription.expires_at = new_expiry_date
        subscription.save
      end
    end
  end
end