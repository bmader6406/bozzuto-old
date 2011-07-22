class CreateConversionConfigurations < ActiveRecord::Migration
  def self.up
    create_table :conversion_configurations do |t|
      t.string :name

      t.string :google_send_to_friend_label
      t.string :google_send_to_phone_label
      t.string :google_contact_label

      t.string :bing_send_to_friend_action_id
      t.string :bing_send_to_phone_action_id
      t.string :bing_contact_action_id

      t.integer :property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :conversion_configurations
  end
end
