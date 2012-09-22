module ActionView
  module Helpers   
    def open_questionnaires(plan)
      format_limit(plan, "open_questionnaires")
    end
    
    def open_questionnaires_limit(plan)
      format_limit(plan, "open_questionnaires", :noun => "published survey", :period => "at a time", :upto => true)
    end
    
    def responses_per_month(plan)
      format_limit(plan, "responses_per_month")
    end
    
    def responses_per_month_limit(plan)
      format_limit(plan, "responses_per_month", :noun => "response", :period => "per month", :upto => true)
    end
    
    def plan_limits(plan)
      "#{open_questionnaires_limit(plan)} with #{responses_per_month_limit(plan).downcase}"
    end

    def responses_limit(product)
      format_limit(product, "responses", :noun => "response", :upto => true)
    end

    def product_open_time(product)
      "Runs for up to #{distance_of_time_in_words product.days.days}"
    end

    def product_extra_time_pricing(product)
      "+ #{product.extra_time_price.format} / additional #{pluralize product.extra_time_days, "day"}"
    end

    def product_extra_responses_pricing(product)
      "+ #{product.extra_responses_price.format} / additional #{pluralize product.extra_responses_quantity, "response"}"
    end

    def product_limits(product)
      "#{product_open_time product} with #{responses_limit(product).downcase}"
    end
    
    private
    def format_limit(plan, field, options={})
      if plan.respond_to?("unlimited_#{field}") && plan.send("unlimited_#{field}")
        n = "Unlimited"
        if options[:noun]
          n = "#{n} #{options[:noun].pluralize}"
        end
      else
        n = number_with_delimiter(plan.send(field))
        if options[:noun]
          n = pluralize(n, options[:noun])
        end
        if options[:upto]
          n = "Up to #{n}"
        end
        if options[:period]
          n = "#{n} #{options[:period]}"
        end
      end
      return n
    end
  end
end