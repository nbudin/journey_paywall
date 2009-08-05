# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'
require 'paywall_helpers'

config.gem 'money'
config.gem 'google4r-checkout', :lib => 'google4r/checkout'
Journey::QuestionnaireExtensions.register_extension(JourneyPaywall::QuestionnaireExtensions)
Journey::UserOptions.add_logged_out_option("Subscribe", {:controller => "subscriptions", :action => "index"})
Journey::UserOptions.add_logged_in_option("Subscription", {:controller => "subscriptions", :action => "index"})
