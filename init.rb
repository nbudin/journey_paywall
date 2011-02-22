# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'
require 'paywall_helpers'
require 'yaml'
require 'google4r/checkout'

Journey::QuestionnaireExtensions.register_extension(JourneyPaywall::QuestionnaireExtensions)
Journey::SiteOptions.prepublish_url_options = { :controller => "prepublish", :action => "index" }

Journey::UserOptions.hook do |nb, controller| 
  nb.nav_item((controller.logged_in? ? "Subscription" : "Subscribe"), {:controller => "subscriptions", :action => "index"})
end

begin
  Journey::Dashboard.add_dashbox("subscriptions/dashbox", :right)
  Journey::SiteOptions.add_additional_stylesheet "subscriptions"
rescue
end

yamlpath = "#{RAILS_ROOT}/config/journey_paywall.yml"
begin
  JourneyPaywall.configuration = YAML.load_file(yamlpath)
rescue
  puts "WARNING: Couldn't load #{yamlpath} file.  The Google Checkout integration will not work."
end
