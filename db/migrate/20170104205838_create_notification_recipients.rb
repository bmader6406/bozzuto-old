class CreateNotificationRecipients < ActiveRecord::Migration
  def change
    create_table :notification_recipients do |t|
      t.integer :admin_user_id
      t.string  :email

      t.timestamps null: false
    end

    add_foreign_key :notification_recipients, :admin_users, on_delete: :cascade

    add_index :notification_recipients, :admin_user_id, unique: true
    add_index :notification_recipients, :email,         unique: true
  end
end
