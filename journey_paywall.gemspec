# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.version       = "1.0.6"

  gem.authors       = ["Nat Budin"]
  gem.email         = ["natbudin@gmail.com"]
  gem.summary       = %q{Paid subscriptions for Journey}
  gem.description   = %q{Adds support for subscriptions to Journey.  Subscriptions require monthly payment in order to publish surveys.}
  gem.homepage      = "http://journeysurveys.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "journey_paywall"
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'activerecord', '~> 2.3.5'
  gem.add_dependency "google4r-checkout", "1.1.0"
  
  gem.add_development_dependency "shoulda", ">= 0"
  gem.add_development_dependency "rcov", ">= 0"
end
