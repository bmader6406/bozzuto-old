class AddPositionToStates < ActiveRecord::Migration
  class State < ActiveRecord::Base
  end

  def self.up
    add_column :states, :position, :integer
    add_index :states, :position

    State.reset_column_information

    State.all.each_with_index do |state, i|
      state.update_attribute(:position, i + 1)
    end
  end

  def self.down
    remove_column :states, :position
  end
end
