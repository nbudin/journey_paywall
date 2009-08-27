module PaymentMethod
  def PaymentMethod.included(c)
    c.class_eval do
      has_one :subscription, :as => :payment_method
      
      def initiate(message=nil)
        raise "This is an abstract method."
      end
      
      def request_payment(amount=nil)
        request_payment_inner(amount || subscription.subscription_plan.price)
      end
      
      protected
      
      def request_payment_inner(amount)
        raise "This is an abstract method."
      end
    end
  end
end