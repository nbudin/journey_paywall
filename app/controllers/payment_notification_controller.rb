class PaymentNotificationController < ApplicationController
  def google
    authenticate_or_request_with_http_basic("Google Checkout notification endpoint") do |merchant_id, merchant_key|
      unless PaymentMethods::GoogleSubscription.merchant_credentials_match?(merchant_id, merchant_key)
        return head :unauthorized
      end
    end
    
    frontend = PaymentMethods::GoogleSubscription.frontend
    handler = frontend.create_notification_handler
        
    begin
       notification = handler.handle(request.raw_post) # raw_post contains the XML
    rescue Google4R::Checkout::UnknownNotificationType
       # This can happen if Google adds new commands and Google4R has not been
       # upgraded yet. It is not fatal.
       render :text => 'ignoring unknown notification type', :status => 200
       return
    end
    
    if notification.kind_of? Google4R::Checkout::NewOrderNotification
      notification.shopping_cart.items.each do |item|
        if item.private_data and item.private_data[:subscription_id]
          @subscription = Subscription.find(item.private_data[:subscription_id])

          @gs = @subscription.payment_method
          @gs.google_order_number = notification.google_order_number
          @gs.financial_order_state = notification.financial_order_state
          @gs.save
        end
      end
    elsif notification.kind_of? Google4R::Checkout::OrderStateChangeNotification
      @gs = PaymentMethods::GoogleSubscription.find_by_google_order_number(notification.google_order_number)
      @gs.financial_order_state = notification.new_financial_order_state
      @gs.save
    end
    
    notification_acknowledgement = Google4R::Checkout::NotificationAcknowledgement.new(notification)
    render :xml => notification_acknowledgement, :status => 200
  end
end
