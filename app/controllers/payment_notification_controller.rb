class PaymentNotificationController < ApplicationController
  def google
    authenticate_or_request_with_http_basic("Google Checkout notification endpoint") do |merchant_id, merchant_key|
      PaymentMethods::GoogleSubscription.merchant_credentials_match?(merchant_id, merchant_key)
    end
    
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
        
    if notification.kind_of? Google4R::Checkout::NewOrderNotification
      is_subscription = false
      
      notification.shopping_cart.items.each do |item|
        if item.private_data and item.private_data["subscription_id"]
          is_subscription = true
          
          @subscription = Subscription.find(item.private_data["subscription_id"])
          if @subscription.nil?
            return head :text => "No subscription with ID #{item.private_data["subscription_id"]}", :status => 404
          end

          @gs = @subscription.payment_method
          @gs.google_order_number = notification.google_order_number
          @gs.financial_order_state = notification.financial_order_state
          @gs.save
        end
      end 
      
      unless is_subscription
        @order = PaymentMethods::GoogleOrder.find_by_google_order_number(notification.google_order_number)
        @order.financial_order_state = notification.financial_order_state
        @order.save
      end
    elsif notification.kind_of? Google4R::Checkout::OrderStateChangeNotification
      @subscription = PaymentMethods::GoogleSubscription.find_by_google_order_number(notification.google_order_number)
      if @subscription
        @subscription.financial_order_state = notification.new_financial_order_state
        @subscription.save
      else
        @order = PaymentMethods::GoogleOrder.find_by_google_order_number(notification.google_order_number)
        if @order.nil?
          return head :text => "No record found with order number #{notification.google_order_number}", :status => 404
        end
        
        @order.financial_order_state = notification.new_financial_order_state
        @order.save
      end
    end
    
    if @subscription
      if @subscription.expired?
        if @subscription.financial_order_state == "CHARGEABLE"
          # auto-bill when it becomes chargeable
          @subscription.payment_method.request_payment
        end
      end
    end
    
    notification_acknowledgement = Google4R::Checkout::NotificationAcknowledgement.new(notification)
    render :xml => notification_acknowledgement, :status => 200
  end
end
