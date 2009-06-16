# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'


config.gem 'money'
config.gem 'activemerchant', :lib => "active_merchant"
Journey::QuestionnaireExtensions.register_extension(JourneyPaywall::QuestionnaireExtensions)
