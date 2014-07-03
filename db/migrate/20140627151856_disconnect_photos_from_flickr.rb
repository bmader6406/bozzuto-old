class DisconnectPhotosFromFlickr < ActiveRecord::Migration
  def self.up
    ###
    # Set mobile only flag on photos
    #

    add_column :photos, :show_to_mobile, :boolean, :null => false, :default => false

    # Set :mobile_only on :photos to true for photos in the 'mobile' group
    execute <<-SQL
      UPDATE photos AS p
      INNER JOIN photo_groups_photos AS pgp
        ON pgp.photo_id = p.id
      INNER JOIN photo_groups AS pg
        ON pg.id = pgp.photo_group_id
        AND pg.flickr_raw_title = 'mobile'
      SET p.show_to_mobile = true
    SQL

    ###
    # Set photo_group_id directly on photo
    #
    # This is switching from a many-to-many to a belongs to, so
    # use only the first non-'mobile' photo group
    #

    add_column :photos, :photo_group_id, :integer

    # Set :photo_group_id on :photos to the id of the first
    # group that isn't 'mobile'
    execute <<-SQL
      UPDATE photos AS p
      SET photo_group_id = (
        SELECT photo_group_id
        FROM photo_groups_photos AS pgp
        INNER JOIN photo_groups AS pg
          ON pg.id = pgp.photo_group_id
        WHERE photo_id = p.id
          AND pg.flickr_raw_title != 'mobile'
        LIMIT 1
      )
    SQL

    ###
    # Move property_id from photo_sets to photos
    #

    add_column :photos, :property_id, :integer

    # Set property_id on photos to the photo set's property id
    execute <<-SQL
      UPDATE photos AS p
      INNER JOIN photo_sets AS ps
        ON ps.id = p.photo_set_id
      SET p.property_id = ps.property_id
    SQL

    # Add null constraint on :property_id
    change_column :photos, :property_id, :integer, :null => false

    ###
    # Remove the 'For Mobile' group
    #

    execute "DELETE FROM photo_groups WHERE flickr_raw_title = 'mobile'"

    ###
    # Remove unused columns
    #

    remove_column :photos, :flickr_photo_id
    remove_column :photos, :photo_set_id
    remove_column :photo_groups, :flickr_raw_title

    ###
    # Drop unused tables
    #

    drop_table :photo_sets
    drop_table :photo_groups_photos
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
