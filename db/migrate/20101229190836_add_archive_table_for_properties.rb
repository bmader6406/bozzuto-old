class AddArchiveTableForProperties < ActiveRecord::Migration

  # TODO What to do with this migration, referencing a defunct gem - RF 2-8-16
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
