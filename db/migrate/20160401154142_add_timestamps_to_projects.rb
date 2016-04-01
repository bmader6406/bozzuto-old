class AddTimestampsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :created_at, :datetime, null: false, default: Time.current
    add_column :projects, :updated_at, :datetime, null: false, default: Time.current
  end
end
