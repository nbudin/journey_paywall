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
      
      subscr = nil

      permissions.each do |perm|
        if perm.person
          puts "trying to find subscription for #{perm.person.name}"
          break if subscr = Subscription.find_all_by_person(perm.person)[0]
        end
      end
      
      if subscr.nil?
        subscr = Subscription.new(options[:attrs] || {})
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
            errors.add_to_base("You are already at your subscription limit for published surveys.  You "+
              "must either upgrade your subscription, or switch some surveys back into design mode.")
          end
        end
      end
    end
  end
end