class FixPositionsForPhotos < ActiveRecord::Migration
  # Photos are currently positioned scoped to the property.
  #
  # This migration updates the positions to be scoped to
  # property AND photo group

  class Property < ActiveRecord::Base; end

  class Community < Property
    has_many :photos,
             :class_name  => '::FixPositionsForPhotos::Photo',
             :foreign_key => :property_id,
             :dependent   => :destroy
  end

  class ApartmentCommunity < Community
    # Don't include module when determining STI type
    self.store_full_sti_class = false
  end

  class HomeCommunity < Community
    self.store_full_sti_class = false
  end

  class PhotoGroup < ActiveRecord::Base
    acts_as_list

    has_many :photos,
             :class_name => '::FixPositionsForPhotos::Photo',
             :dependent  => :nullify

    named_scope :positioned, { :order => 'photo_groups.position ASC' }
  end

  class Photo < ActiveRecord::Base
    acts_as_list

    belongs_to :photo_group, :class_name => '::FixPositionsForPhotos::PhotoGroup'
    belongs_to :property,    :class_name => '::FixPositionsForPhotos::Property'

    named_scope :positioned, {
      :include => :photo_group,
      :order   => 'photo_groups.position ASC, photos.position ASC'
    }

    named_scope :in_group, lambda { |group|
      { :conditions => { :photo_group_id => group.id } }
    }


    private

    def scope_condition
      "property_id = #{property_id} AND photo_group_id = #{photo_group_id}"
    end
  end


  def self.up
    [ApartmentCommunity, HomeCommunity].each do |klass|
      klass.all.each do |community|
        PhotoGroup.positioned.each do |group|
          community.photos.positioned.in_group(group).each_with_index do |photo, i|
            photo.update_attribute(:position, i + 1)
          end
        end
      end
    end
  end

  def self.down
  end
end
