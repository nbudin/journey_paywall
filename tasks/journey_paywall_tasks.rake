# desc "Explaining what the task does"
# task :journey_paywall do
#   # Task goes here
# end

namespace :journey_paywall do
  desc "migrates my plugin's migration files into the database."
  task :migrate => :environment do
      ActiveRecord::Migrator.migrate(File.expand_path(File.dirname(__FILE__) + "/../db/migrate"))
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end
end