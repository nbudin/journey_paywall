module PaymentMethod
  def PaymentMethod.included(c)
    c.class_eval do
      has_one :subscription, :as => :payment_method
      has_one :order, :as => :payment_method
      
      def initiate(options={})
        raise "This is an abstract method."
      end
      
      def request_payment(amount=nil)
        request_payment_inner(amount || default_amount)
      end
      
      protected
      
      def default_amount
        if subscription
          subscription.subscription_plan.price
        elsif order
          order.price
        else
          raise "No associated subscription or order, cannot calculate default amount"
        end
      end
      
      def request_payment_inner(amount)
        raise "This is an abstract method."
      end
      
      def payment_successful(amount)
        if subscription
          subscription.last_paid_at = Time.now
          subscription.save
        elsif order
          order.paid_at = Time.now
          order.save
        else
          raise "No associated subscription or order, cannot mark as paid"
        end
      end
    end
  end
end