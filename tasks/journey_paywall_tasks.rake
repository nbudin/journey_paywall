# desc "Explaining what the task does"
# task :journey_paywall do
#   # Task goes here
# end

namespace :journey_paywall do
  desc "add the paywall tables and columns to the database"
  task :migrate => :environment do
      ActiveRecord::Migrator.migrate(File.expand_path(File.dirname(__FILE__) + "/../db/migrate"))
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end

  desc "remove the paywall tables and columns from the database"
  task :rollback => :environment do
    ActiveRecord::Migrator.down(File.expand_path(File.dirname(__FILE__) + "/../db/migrate"))
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end
  
  desc "attempt to charge all subscriptions for which payment is due"
  task :charge_subscriptions => :environment do
    logger = Logger.new(STDERR)
    Subscription.active.all.each do |s|
      begin
        if s.expired? and s.payment_method
          s.payment_method.request_payment
        end
      rescue Google4R::Checkout::GoogleCheckoutError => e
        logger.error "Google Checkout error while requesting payment for #{s.sid}"
        logger.error "#{e.message}"
      rescue Exception => e
        logger.error "Error while requesting payment for #{s.sid}"
        logger.error e
      end
    end
  end
end

task :cron => ['journey_paywall:charge_subscriptions']
