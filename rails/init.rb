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
if ENV['GOOGLE_CHECKOUT_MERCHANT_ID'] && ENV['GOOGLE_CHECKOUT_MERCHANT_KEY']
  JourneyPaywall.configuration = {
    'merchant_id' => ENV["GOOGLE_CHECKOUT_MERCHANT_ID"],
    'merchant_key' => ENV["GOOGLE_CHECKOUT_MERCHANT_KEY"],
    'use_sandbox' => ENV["GOOGLE_CHECKOUT_USE_SANDBOX"]
  }
elsif File.exist?(yamlpath)
  JourneyPaywall.configuration = YAML.load_file(yamlpath)
else
  puts "WARNING: Couldn't find GOOGLE_CHECKOUT env variables or #{yamlpath} file.  The Google Checkout integration will not work."
end
