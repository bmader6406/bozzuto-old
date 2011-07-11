class AddMediamindIdsToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :send_to_friend_mediamind_id, :string
    add_column :properties, :send_to_phone_mediamind_id, :string
    add_column :properties, :contact_mediamind_id, :string
  end

  def self.down
    remove_column :properties, :send_to_friend_mediamind_id
    remove_column :properties, :send_to_phone_mediamind_id
    remove_column :properties, :contact_mediamind_id
  end
end
