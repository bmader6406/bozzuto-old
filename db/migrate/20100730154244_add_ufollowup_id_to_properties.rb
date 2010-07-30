class AddUfollowupIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :ufollowup_id, :integer
  end

  def self.down
    remove_column :properties, :ufollowup_id
  end
end
