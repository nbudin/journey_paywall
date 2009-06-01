class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
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
    Questionnaire.all(:include => :permissions).each do |q|
      s = q.obtain_subscription(:skip_save => true)
      if s
        s.unlimited = true
        q.permitted_people("edit").each do |person|
            s.grant(person)
        end
        s.save

        q.reload
        q.obtain_subscription
      end
    end
  end

  def self.down
    remove_column :questionnaires, :subscription_id
    drop_table :subscriptions
  end
end
