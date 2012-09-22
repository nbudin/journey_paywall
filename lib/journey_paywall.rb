# Journey-paywall

module JourneyPaywall
  @@configuration = {}
  
  def self.configuration
    @@configuration
  end
  
  def self.configuration=(configuration)
    @@configuration = configuration
  end
  
  module QuestionnaireExtensions
    def self.included(base)
      base.class_eval do
        belongs_to :subscription
        has_many :orders
        
        add_creator_warning_hook(lambda do |person|
          subscrs = Subscription.find_all_by_person(person)
          if subscrs.size == 0
            "To publish this survey, you'll need a paid Journey subscription."
          else
            unless subscrs.any? { |subscr|
              not subscr.questionnaire_over_limit?(Questionnaire.new)
            }
              "You've hit your subscription's limit on simultaneously published surveys!  To 
              publish this one, you'll have to upgrade your subscription, or close one of your
              existing surveys first."
            end
          end
        end)
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
    
    def total_paid_days
      Order.total_days(orders.paid)
    end
    
    def total_paid_responses
      Order.total_responses(orders.paid)
    end
    
    def paid_days_end_at
      Order.days_end_at(orders.paid)
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