class AddDistanceToHospitalMembership < ActiveRecord::Migration
  def self.up
    add_column :hospital_memberships, :distance, :float
   
    add_index :hospital_memberships, :distance
  end

  def self.down
    remove_column :hospital_memberships, :distance
  end
end
