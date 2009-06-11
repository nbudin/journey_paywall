class CreateSubscriptionPlans < ActiveRecord::Migration
  def self.up
    create_table :subscription_plans do |t|
      t.string :name
      t.boolean :unlimited
      t.integer :open_questionnaires
      t.integer :responses_per_month
      t.string :rebill_period
      t.integer :cents
      t.string :currency
      t.integer :grace_period
      t.boolean :allow_public_signup
    end
  end

  def self.down
    drop_table :subscription_plans
  end
end
