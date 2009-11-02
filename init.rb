# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'
require 'paywall_helpers'
require 'yaml'

config.gem 'money'
config.gem 'nbudin-google4r-checkout', :lib => 'google4r/checkout', :source => 'http://gemcutter.org',
           :version => "~> 1.0.11"
Journey::QuestionnaireExtensions.register_extension(JourneyPaywall::QuestionnaireExtensions)
Journey::UserOptions.add_logged_out_option("Subscribe", {:controller => "subscriptions", :action => "index"})
Journey::UserOptions.add_logged_in_option("Subscription", {:controller => "subscriptions", :action => "index"})

Journey::SiteOptions.default_layout = "journey_with_paywall"

yamlpath = "#{RAILS_ROOT}/config/journey_paywall.yml"
begin
  JourneyPaywall.configuration = YAML.load_file(yamlpath)
rescue
  puts "WARNING: Couldn't load #{yamlpath} file.  The Google Checkout integration will not work."
end
