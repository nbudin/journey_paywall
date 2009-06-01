# Include hook code here

require 'journey_paywall'

Questionnaire.send(:include, JourneyPaywall::QuestionnaireExtensions)