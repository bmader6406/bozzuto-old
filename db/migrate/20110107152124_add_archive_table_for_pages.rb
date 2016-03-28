class AddArchiveTableForPages < ActiveRecord::Migration

  unless defined?(ActsAsArchive)
    class ActsAsArchive
      def self.update(*args)
        # no-op
      end
    end
  end

  def self.up
    ActsAsArchive.update Page
  end

  def self.down
    drop_table :archived_pages
  end
end
