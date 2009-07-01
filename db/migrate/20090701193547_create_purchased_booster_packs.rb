class CreatePurchasedBoosterPacks < ActiveRecord::Migration
  def self.up
    create_table :purchased_booster_packs do |t|
      t.integer :subscription_id
      t.integer :booster_pack_id
      t.timestamp :expires_at
      t.timestamps
    end
  end

  def self.down
    drop_table :purchased_booster_packs
  end
end
