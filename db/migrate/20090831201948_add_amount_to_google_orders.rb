class AddAmountToGoogleOrders < ActiveRecord::Migration
  def self.up
    add_column :google_orders, :cents, :integer
    add_column :google_orders, :currency, :string
  end

  def self.down
    remove_column :google_orders, :currency
    remove_column :google_orders, :cents
  end
end
