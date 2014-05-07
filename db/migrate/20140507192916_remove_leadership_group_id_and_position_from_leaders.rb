class RemoveLeadershipGroupIdAndPositionFromLeaders < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      INSERT INTO leaderships (leader_id, leadership_group_id, position)
      SELECT id, leadership_group_id, position FROM leaders
    SQL

    remove_column :leaders, :leadership_group_id
    remove_column :leaders, :position
  end

  def self.down
    add_column :leaders, :leadership_group_id, :integer
    add_column :leaders, :position, :integer

    execute <<-SQL
      UPDATE leaders
      INNER JOIN leaderships ON leaders.id = leaderships.leader_id
      SET leaders.leadership_group_id = leaderships.leadership_group_id,
          leaders.position = leaderships.position
    SQL

    execute <<-SQL
      DELETE FROM leaderships
    SQL

    change_column :leaders, :leadership_group_id, :integer, :null => false
  end
end
