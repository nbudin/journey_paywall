# Include hook code here

require 'journey_paywall'
require 'journey_questionnaire'
require 'paywall_helpers'
require 'yaml'

config.gem 'money'
config.gem 'nbudin-google4r-checkout', :lib => 'google4r/checkout', :source => 'http://gems.github.com'
Journey::QuestionnaireExtensions.register_extension(JourneyPaywall::QuestionnaireExtensions)
Journey::UserOptions.add_logged_out_option("Subscribe", {:controller => "subscriptions", :action => "index"})
Journey::UserOptions.add_logged_in_option("Subscription", {:controller => "subscriptions", :action => "index"})

yamlpath = "#{RAILS_ROOT}/config/journey_paywall.yml"
begin
  conf = YAML.load_file(yamlpath)
rescue
  puts "WARNING: Couldn't load #{yamlpath} file.  The Google Checkout integration will not work."
end

if conf
  googleconf = conf['google']
  if googleconf
    JourneyPaywall.merchant_id = googleconf['merchant_id']
    JourneyPaywall.merchant_key = googleconf['merchant_key']
    if googleconf['use_sandbox']
      JourneyPaywall.use_sandbox
    end
  end
end