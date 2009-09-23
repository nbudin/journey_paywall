class AddPaymentMethodAssociation < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :payment_method_id, :integer
    add_column :subscriptions, :payment_method_type, :string
  end

  def self.down
    remove_column :subscriptions, :payment_method_id
    remove_column :subscriptions, :payment_method_type
  end
end
