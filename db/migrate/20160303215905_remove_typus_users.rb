class RemoveTypusUsers < ActiveRecord::Migration
  def change
    drop_table :typus_users
  end

  def down
    create_table :typus_users do |t|
      t.string  :first_name,       null: false
      t.string  :last_name,        null: false
      t.string  :role,             null: false
      t.string  :email,            null: false
      t.boolean :status,           null: false, default: false
      t.string  :token,            null: false
      t.string  :salt,             null: false
      t.string  :crypted_password, null: false
      t.string  :preferences

      t.timestamps
    end
  end
end
