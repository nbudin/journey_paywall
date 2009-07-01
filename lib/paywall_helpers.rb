module ActionView
  module Helpers   
    def open_questionnaires(plan)
      format_plan_limit(plan, "open_questionnaires")
    end
    
    def open_questionnaires_limit(plan)
      format_plan_limit(plan, "open_questionnaires", :noun => "published survey", :period => "at a time", :upto => true)
    end
    
    def responses_per_month(plan)
      format_plan_limit(plan, "responses_per_month")
    end
    
    def responses_per_month_limit(plan)
      format_plan_limit(plan, "responses_per_month", :noun => "response", :period => "per month", :upto => true)
    end
    
    def plan_limits(plan)
      "#{open_questionnaires_limit(plan)} with #{responses_per_month_limit(plan).downcase}"
    end
    
    private
    def format_plan_limit(plan, field, options={})
      if plan.send("unlimited_#{field}")
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