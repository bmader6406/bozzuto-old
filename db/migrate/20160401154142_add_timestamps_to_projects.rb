class AddTimestampsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :created_at, :datetime, null: false, default: Time.utc(2016, 4, 1, 15, 45, 39)
    add_column :projects, :updated_at, :datetime, null: false, default: Time.utc(2016, 4, 1, 15, 45, 39)
  end
end
