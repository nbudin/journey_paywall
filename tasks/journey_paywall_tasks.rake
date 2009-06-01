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
    ActiveRecord::Migrator.rollback(File.expand_path(File.dirname(__FILE__) + "/../db/migrate"))
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end
end