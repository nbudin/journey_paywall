# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{journey_paywall}
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nat Budin"]
  s.date = %q{2011-08-18}
  s.email = %q{natbudin@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "README",
    "Rakefile",
    "VERSION",
    "app/controllers/payment_notification_controller.rb",
    "app/controllers/prepublish_controller.rb",
    "app/controllers/subscription_plans_controller.rb",
    "app/controllers/subscriptions_controller.rb",
    "app/helpers/payment_notification_helper.rb",
    "app/helpers/subscriptions_helper.rb",
    "app/models/payment_method.rb",
    "app/models/payment_methods/google_order.rb",
    "app/models/payment_methods/google_subscription.rb",
    "app/models/subscription.rb",
    "app/models/subscription_plan.rb",
    "app/views/prepublish/_subscription_options.html.erb",
    "app/views/prepublish/index.html.erb",
    "app/views/prepublish/set_subscription.html.erb",
    "app/views/stylesheets/subscriptions.css.erb",
    "app/views/subscription_plans/_form.html.erb",
    "app/views/subscription_plans/destroy.html.erb",
    "app/views/subscription_plans/edit.html.erb",
    "app/views/subscription_plans/index.html.erb",
    "app/views/subscription_plans/new.html.erb",
    "app/views/subscriptions/_dashbox.html.erb",
    "app/views/subscriptions/_new.html.erb",
    "app/views/subscriptions/_paged_results.html.erb",
    "app/views/subscriptions/_payment_method_form.html.erb",
    "app/views/subscriptions/_subscription.html.erb",
    "app/views/subscriptions/_subscription_plan_ad.erb",
    "app/views/subscriptions/_toplevel_tabs.html.erb",
    "app/views/subscriptions/all.html.erb",
    "app/views/subscriptions/create.html.erb",
    "app/views/subscriptions/index.html.erb",
    "app/views/subscriptions/show.html.erb",
    "config/routes.rb",
    "db/migrate/20090531154800_create_subscriptions.rb",
    "db/migrate/20090609185816_create_subscription_plans.rb",
    "db/migrate/20090609202935_populate_initial_subscriptions.rb",
    "db/migrate/20090827143915_create_google_subscriptions.rb",
    "db/migrate/20090827215720_add_payment_method_association.rb",
    "db/migrate/20090831193457_create_google_orders.rb",
    "db/migrate/20090831201948_add_amount_to_google_orders.rb",
    "db/migrate/20090924154816_add_cancelled_at_to_subscriptions.rb",
    "db/migrate/20100221145600_add_subscription_blurb.rb",
    "db/migrate/20100221150000_add_startup_cost.rb",
    "init.rb",
    "install.rb",
    "journey_paywall.gemspec",
    "lib/journey_paywall.rb",
    "lib/paywall_helpers.rb",
    "rails/init.rb",
    "tasks/journey_paywall_tasks.rake",
    "test/fixtures/booster_packs.yml",
    "test/fixtures/purchased_booster_packs.yml",
    "test/functional/payment_notification_controller_test.rb",
    "test/journey_paywall_test.rb",
    "test/test_helper.rb",
    "test/unit/helpers/payment_notification_helper_test.rb",
    "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/nbudin/journey_paywall}
  s.licenses = ["All rights reserved"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Paid subscriptions for Journey}
  s.test_files = [
    "test/functional/payment_notification_controller_test.rb",
    "test/journey_paywall_test.rb",
    "test/test_helper.rb",
    "test/unit/helpers/payment_notification_helper_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 2.3.5"])
      s.add_runtime_dependency(%q<google4r-checkout>, ["= 1.1.beta2"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, ["~> 2.3.5"])
      s.add_dependency(%q<google4r-checkout>, ["= 1.1.beta2"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 2.3.5"])
    s.add_dependency(%q<google4r-checkout>, ["= 1.1.beta2"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

