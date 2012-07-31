class CreateRecurringEmails < ActiveRecord::Migration
  def self.up
    create_table :recurring_emails do |t|
      t.string   :email_address, :null => false
      t.string   :token,         :null => false
      t.text     :property_ids
      t.boolean  :recurring,     :default => false
      t.datetime :last_sent_at
      t.string   :state,         :default => 'active'

      t.timestamps
    end

    add_index :recurring_emails, :token
    add_index :recurring_emails, :email_address
    add_index :recurring_emails, :state
  end

  def self.down
    drop_table :recurring_emails
  end
end
