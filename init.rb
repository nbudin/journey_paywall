# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'


config.gem 'money'
Journey::QuestionnaireExtensions.register_extension(JourneyPaywall::QuestionnaireExtensions)
