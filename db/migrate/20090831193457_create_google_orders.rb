class CreateGoogleOrders < ActiveRecord::Migration
  def self.up
    create_table :google_orders do |t|
      t.timestamps
      t.column :google_subscription_id, :integer
      t.column :google_order_number, :string
      t.column :financial_order_state, :string
    end
    
    add_index :google_orders, :google_order_number, :unique => true
  end

  def self.down
    drop_table :google_orders
  end
end
