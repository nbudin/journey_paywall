class PopulateInitialSubscriptions < ActiveRecord::Migration
  def self.up
    courtesy = SubscriptionPlan.create(:name => "Courtesy",
      :unlimited => true,
      :cents => 0,
      :rebill_period => 'never'
      )
    
    # populate initial owners
    # grandfather in unlimited entitlements for the existing owners
    owners = Questionnaire.all(:include => :permissions).collect do |q|
      q.permitted_people("edit")
    end
    owners.flatten.uniq.compact.each do |p|
      s = Subscription.create(:subscription_plan => courtesy)
      s.grant(p)
    end
    
    Questionnaire.all(:include => :permissions).each do |q|
      puts "-- " "Populating initial owner for questionnaire #{q.id}"
      s = q.obtain_subscription
      if s.nil?
        puts "WARNING: couldn't find subscription; this questionnaire will be left unchanged!"
      end
    end
  end

  def self.down
  end
end
