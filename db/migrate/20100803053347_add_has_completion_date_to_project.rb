class AddHasCompletionDateToProject < ActiveRecord::Migration
  def self.up
    add_column :properties, :has_completion_date, :boolean,
      :default => true,
      :null => false
  end

  def self.down
    remove_column :properties, :has_completion_date
  end
end
