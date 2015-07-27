class RemoveNullConstraintsForClosedOfficeHours < ActiveRecord::Migration
  def self.up
    change_column :office_hours, :opens_at,         :string, :null => true
    change_column :office_hours, :opens_at_period,  :string, :null => true, :default => 'AM'
    change_column :office_hours, :closes_at,        :string, :null => true
    change_column :office_hours, :closes_at_period, :string, :null => true, :default => 'PM'
  end

  def self.down
    change_column :office_hours, :opens_at,         :string, :null => false
    change_column :office_hours, :opens_at_period,  :string, :null => false, :default => 'AM'
    change_column :office_hours, :closes_at,        :string, :null => false
    change_column :office_hours, :closes_at_period, :string, :null => false, :default => 'PM'
  end
end
