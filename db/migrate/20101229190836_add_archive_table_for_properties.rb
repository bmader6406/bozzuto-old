class AddArchiveTableForProperties < ActiveRecord::Migration

  unless defined?(ActsAsArchive)
    class ActsAsArchive
      def self.update(*args)
        # no-op
      end
    end
  end

  def self.up
    ActsAsArchive.update Property
  end

  def self.down
    drop_table :archived_properties
  end
end
