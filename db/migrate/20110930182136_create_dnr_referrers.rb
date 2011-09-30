class CreateDnrReferrers < ActiveRecord::Migration
  def self.up
    create_table :dnr_referrers do |t|
      t.string :domain_name, :null => false
      t.string :pattern,     :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :dnr_referrers
  end
end
