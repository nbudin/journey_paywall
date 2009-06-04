# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'

Journey::Questionnaire.register_extension(JourneyPaywall::QuestionnaireExtensions)
