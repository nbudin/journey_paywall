class AddStartupCost < ActiveRecord::Migration
  def self.up
    add_column :subscription_plans, :startup_cost_cents, :integer
    add_column :subscription_plans, :startup_cost_currency, :string
  end

  def self.down
    remove_column :subscription_plans, :startup_cost_cents
    remove_column :subscription_plans, :startup_cost_currency
  end
end