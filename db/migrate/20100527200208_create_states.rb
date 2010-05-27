class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.with_options :null => false do |n|
        n.string :code, :length => 2
        n.string :name
      end
      t.timestamps
    end
  end

  def self.down
    drop_table :states
  end
end
