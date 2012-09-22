class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :product
      t.references :questionnaire
      t.references :payment_method, :polymorphic => true
      t.boolean :supplemental
      
      t.integer :cents
      t.string  :currency
      
      t.integer :responses
      t.integer :days
      
      t.timestamps
      t.timestamp :paid_at
    end
    
    add_index :orders, :questionnaire_id
    add_index :orders, [:payment_method_type, :payment_method_id]
  end

  def self.down
    drop_table :orders
  end
end
