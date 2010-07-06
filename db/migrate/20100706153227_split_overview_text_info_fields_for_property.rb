class SplitOverviewTextInfoFieldsForProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :overview_title, :string
    add_column :properties, :overview_bullet_1, :string
    add_column :properties, :overview_bullet_2, :string
    add_column :properties, :overview_bullet_3, :string
  end

  def self.down
    remove_column :properties, :overview_title
    remove_column :properties, :overview_bullet_1
    remove_column :properties, :overview_bullet_2
    remove_column :properties, :overview_bullet_3
  end
end
