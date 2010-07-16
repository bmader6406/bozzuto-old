class AddCompletionDateToProject < ActiveRecord::Migration
  def self.up
    add_column :properties, :completion_date, :date
  end

  def self.down
    remove_column :properties, :completion_date
  end
end
