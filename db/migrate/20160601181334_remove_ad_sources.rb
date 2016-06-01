class RemoveAdSources < ActiveRecord::Migration
  def up
    drop_table :ad_sources
  end

  def down
    create_table :ad_sources do |t|
      t.string :domain_name, null: false
      t.string :pattern,     null: false
      t.string :value,       null: false

      t.timestamps
    end
  end
end
