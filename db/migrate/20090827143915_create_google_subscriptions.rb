class CreateGoogleSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :google_subscriptions do |t|
      t.timestamps
      t.column :subscription_id, :integer
      t.column :google_order_number, :string
      t.column :financial_order_state, :string
    end
    
    add_index :google_subscriptions, :google_order_number, :unique => true
  end

  def self.down
    drop_table :google_subscriptions
  end
end
