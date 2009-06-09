class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.timestamp :last_paid_at
      t.integer :subscription_plan_id
      t.timestamps
    end
    
    add_column :questionnaires, :subscription_id, :integer
    add_index :questionnaires, :subscription_id
  end

  def self.down
    Permission.destroy_all("permissioned_type = 'Subscription'")
    remove_column :questionnaires, :subscription_id
    drop_table :subscriptions
  end
end
