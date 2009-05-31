class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.boolean :unlimited
      t.timestamp :expires_at
      t.integer :open_questionnaires
      t.integer :responses_per_month
      t.timestamps
    end

    create_table :subscriptions_questionnaires, :id => false do |t|
      t.integer :subscription_id
      t.integer :questionnaire_id
    end

    add_index :subscriptions_questionnaires, :subscription_id
    add_index :subscriptions_questionnaires, :subscription_id

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
    drop_table :subscriptions_questionnaires
    drop_table :subscriptions
  end
end
