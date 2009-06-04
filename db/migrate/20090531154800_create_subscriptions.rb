class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :name
      t.boolean :unlimited
      t.timestamp :expires_at
      t.integer :open_questionnaires
      t.integer :responses_per_month
      t.timestamps
    end
    
    add_column :questionnaires, :subscription_id, :integer
    add_index :questionnaires, :subscription_id

    # populate initial owners
    # grandfather in unlimited entitlements for the existing owners
    owners = Questionnaire.all(:include => :permissions).collect do |q|
      q.permitted_people("edit")
    end
    owners.flatten.uniq.compact.each do |p|
      s = Subscription.create(:name => "Courtesy subscription for #{p.name}")
      s.unlimited = true
      s.save
      s.grant(p)
    end
    
    Questionnaire.all(:include => :permissions).each do |q|
      puts "-- " "Populating initial owner for questionnaire #{q.id}"
      s = q.obtain_subscription
      if s.nil?
        puts "WARNING: couldn't find subscription; this questionnaire will be left unchanged!"
      end
    end
  end

  def self.down
    Permission.destroy_all("permissioned_type = 'Subscription'")
    remove_column :questionnaires, :subscription_id
    drop_table :subscriptions
  end
end
