class RemoveSendToPhoneFields < ActiveRecord::Migration
  def change
    remove_column :conversion_configurations, :google_send_to_phone_label,   :string
    remove_column :conversion_configurations, :bing_send_to_phone_action_id, :string
  end
end
