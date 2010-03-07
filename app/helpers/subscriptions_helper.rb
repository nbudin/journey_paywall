module SubscriptionsHelper
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
end