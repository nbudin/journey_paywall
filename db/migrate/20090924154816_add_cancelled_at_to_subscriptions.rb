class AddCancelledAtToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :cancelled_at, :timestamp
  end

  def self.down
    remove_column :subscriptions, :cancelled_at
  end
end
