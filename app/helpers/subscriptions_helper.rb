module SubscriptionsHelper
  def product_ad(product)
    concat(content_tag(:div, :class => "plan") do
      html = content_tag(:h3, product.name)
      
      html << content_tag(:ul, :class => "limits") do
        content_tag(:li, product_open_time(product)) +
        content_tag(:li, responses_limit(product))
      end
      
      html << content_tag(:div, :class => "price") do
        product.price.format + 
        content_tag(:ul, :class => "extensions") do
          content_tag(:li, product_extra_time_pricing(product)) +
          content_tag(:li, product_extra_responses_pricing(product))
        end
      end
      
      html << yield
    end)
  end

  def subscription_plan_ad(plan)
    concat(content_tag(:div, :class => "plan") do
      html = content_tag(:h3, plan.name)
      
      if plan.blurb.blank?
        html << content_tag(:ul, :class => "limits") do
          content_tag(:li, open_questionnaires_limit(plan)) +
          content_tag(:li, responses_per_month_limit(plan))
        end
      else
        html << plan.blurb
      end
      
      html << content_tag(:div, plan.human_price, :class => "price")
      
      html << yield
    end)
  end
  
  def subscription_class(subscription)
    c = "subscription"
    c << " expired" if subscription.expired?
    c << " cancelled" if subscription.cancelled?
    return c
  end
end