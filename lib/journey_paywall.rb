# Journey-paywall

module JourneyPaywall
  module QuestionnaireExtensions
    def self.included(base)
      base.class_eval do
        belongs_to :subscription
        validate :check_subscription_limits
      end
    end
    
    def obtain_subscription(options = {})
      if subscription
        return subscription
      end

      permissions.each do |perm|
        if perm.person
          subscr = Subscription.find_all_by_person(perm.person)
          next if subscr.nil?
        end
      end
      
      if subscr.nil?
        subscr = Subscription.new
      end
      
      self.subscription = subscr      
      if options[:skip_save] or save
        return self.subscription
      end
    end

    private

    def check_subscription_limits
      if is_open
        if check_subscr = obtain_subscription(:skip_save => true)
          if check_subscr.questionnaire_over_limit?(self)
            errors.add_to_base("You are already at your limit for open questionnaires.")
          end
        end
      end
    end
  end
end