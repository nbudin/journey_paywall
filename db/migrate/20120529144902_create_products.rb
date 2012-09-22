class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      
      t.integer :cents
      t.string  :currency
      t.integer :responses
      t.integer :days

      t.integer :extra_time_price_cents
      t.string  :extra_time_price_currency
      t.integer :extra_time_days
      
      t.integer :extra_responses_price_cents
      t.string :extra_responses_price_currency
      t.integer :extra_responses_quantity
      
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
