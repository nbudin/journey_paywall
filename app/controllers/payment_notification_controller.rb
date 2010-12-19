class PaymentNotificationController < ApplicationController
  before_filter :verify_merchant_credentials, :only => [:google]
  
  def google
    frontend = PaymentMethods::GoogleSubscription.frontend
    handler = frontend.create_notification_handler
        
    begin
       notification = handler.handle(request.raw_post) # raw_post contains the XML
    rescue Google4R::Checkout::UnknownNotificationType
       # This can happen if Google adds new commands and Google4R has not been
       # upgraded yet. It is not fatal.
       logger.warn "Unknown notification type"
       return render :text => 'ignoring unknown notification type', :status => 200
    end
    
    logger.debug request.raw_post
        
    case notification
    when Google4R::Checkout::NewOrderNotification then
      non_recurring_items = false
      
      notification.shopping_cart.items.each do |item|
        if item.private_data and item.private_data["subscription_id"]
          @subscription = Subscription.find(item.private_data["subscription_id"])
          if @subscription.nil?
            return head :text => "No subscription with ID #{item.private_data["subscription_id"]}", :status => 404
          end

          @gs = @subscription.payment_method
          @gs.google_order_number = notification.google_order_number
          @gs.financial_order_state = notification.financial_order_state
          @gs.save
        else
          non_recurring_items = true
        end
      end 
      
      if non_recurring_items
        if @gs
          @order = @gs.google_orders.find_or_create_by_google_order_number(notification.google_order_number)
        else
          @order = PaymentMethods::GoogleOrder.find_by_google_order_number(notification.google_order_number)
        end
        
        if @order
          @order.amount = notification.order_total
          @order.financial_order_state = notification.financial_order_state
          @order.save
        else
          return head :text => "No record found with order number #{notification.google_order_number}", :status => 404
        end
      end
    when Google4R::Checkout::OrderStateChangeNotification then
      @gs = PaymentMethods::GoogleSubscription.find_by_google_order_number(notification.google_order_number)
      @order = PaymentMethods::GoogleOrder.find_by_google_order_number(notification.google_order_number)

      if @gs
        @gs.financial_order_state = notification.new_financial_order_state
        @gs.save
      end
      
      if @order
        @order.financial_order_state = notification.new_financial_order_state
        @order.save
      end

      if @gs.nil? and @order.nil?
        return head :text => "No record found with order number #{notification.google_order_number}", :status => 404
      end
    when Google4R::Checkout::CancelledSubscriptionNotification then
      @gs = PaymentMethods::GoogleSubscription.find_by_google_order_number(notification.google_order_number)
      
      #TODO implement some kind of notification just to the admin if things fail; don't send an error back to Google
      if @gs
        @subscription = @gs.subscription
        if @subscription.nil?
          return head :text => "No subscription attached to GoogleSubscription #{@gs.id}", :status => 500
        end
        
        @subscription.cancelled_at = Time.new
        @subscription.save
      end
    end
    
    notification_acknowledgement = Google4R::Checkout::NotificationAcknowledgement.new(notification)
    render :xml => notification_acknowledgement, :status => 200
  end
  
  private
  def verify_merchant_credentials
    authenticate_or_request_with_http_basic("Google Checkout notification endpoint") do |merchant_id, merchant_key|
      PaymentMethods::GoogleSubscription.merchant_credentials_match?(merchant_id, merchant_key)
    end
  end
end
