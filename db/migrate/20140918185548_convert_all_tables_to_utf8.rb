class ConvertAllTablesToUtf8 < ActiveRecord::Migration
  def self.up
    execute "ALTER DATABASE #{connection.current_database} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"

    connection.tables.each do |table_name|
      execute "ALTER TABLE #{table_name.to_s} CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    end
  end

  def self.down
    execute "ALTER DATABASE #{connection.current_database} DEFAULT CHARACTER SET = latin1 COLLATE latin1_swedish_ci"

    connection.tables.each do |table_name|
      execute "ALTER TABLE #{table_name.to_s} CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
    end
  end
end
