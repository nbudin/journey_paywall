class AddSubscriptionBlurb < ActiveRecord::Migration
  def self.up
    add_column :subscription_plans, :blurb, :text
  end

  def self.down
    remove_column :subscription_plans, :blurb
  end
end