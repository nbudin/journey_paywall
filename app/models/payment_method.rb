module PaymentMethod
  def PaymentMethod.included(c)
    c.class_eval do
      has_one :subscription, :as => :payment_method
      
      def initiate(options={})
        raise "This is an abstract method."
      end
      
      def request_payment(amount=nil)
        request_payment_inner(amount || subscription.subscription_plan.price)
      end
      
      protected
      
      def request_payment_inner(amount)
        raise "This is an abstract method."
      end
      
      def payment_successful(amount)
        subscription.last_paid_at = Time.new
        subscription.save
      end
    end
  end
end