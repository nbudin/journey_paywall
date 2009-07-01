class CreateBoosterPacks < ActiveRecord::Migration
  def self.up
    create_table :booster_packs do |t|
      t.integer :subscription_plan_id
      t.integer :additional_open_questionnaires
      t.integer :additional_responses_per_month
      t.integer :cents
      t.string :currency
      t.boolean :expires_at_month_end
      t.timestamps
    end
    
    add_index :booster_packs, :subscription_plan_id
  end

  def self.down
    drop_table :booster_packs
  end
end
