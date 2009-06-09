class CreateSubscriptionPlans < ActiveRecord::Migration
  def self.up
    create_table :subscription_plans do |t|
      t.string :name
      t.boolean :unlimited
      t.integer :open_questionnaires
      t.integer :responses_per_month
      t.string :rebill_period
      t.integer :price
      t.integer :grace_period
    end
  end

  def self.down
    drop_table :subscription_plans
  end
end
