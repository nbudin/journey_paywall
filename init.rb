# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'

Journey::QuestionnaireExtensions.register_extension(JourneyPaywall::QuestionnaireExtensions)
