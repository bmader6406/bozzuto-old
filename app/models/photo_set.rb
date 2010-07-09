class PhotoSet < ActiveRecord::Base
  before_validation :set_title
  after_create :update_photos

  belongs_to :property
  belongs_to :apartment_community, :foreign_key => :property_id
  belongs_to :home_community, :foreign_key => :property_id
  has_many :photos, :order => 'position ASC'

  validates_presence_of :title, :flickr_set_number


  def validate
    if flickr_set.nil?
      errors.add(:flickr_set_number, 'cannot be found')
    end
  end

  def self.flickr_user
    @user ||= Fleakr.user(APP_CONFIG[:flickr]['username'])
  end

  def flickr_user
    self.class.flickr_user
  end

  def update_photos
    if flickr_set.present?
      photos.destroy_all

      flickr_set.photos.each do |photo|
        groups = groups_for_photo(photo)

        unless groups.empty?
          file = choose_size(photo).save_to(RAILS_ROOT + '/tmp')

          self.photos << Photo.new(
            :title               => photo.title,
            :image               => File.open(file.path),
            :flickr_photo_number => photo.id,
            :photo_groups        => groups
          )

          File.delete(file.path)
        end
      end
    end
    true
  end

  def flickr_set
    @flickr_set ||= if flickr_set_number.nil?
      nil
    else
      flickr_user.sets.find { |set| set.id == flickr_set_number }
    end
  end


  protected

  def set_title
    self.title = flickr_set.try(:title)
    true
  end

  def choose_size(photo)
    if photo.large.present? && photo.large.width.to_i >= 870 && photo.large.height.to_i >= 375
      photo.large
    else
      photo.original
    end
  end

  def groups_for_photo(photo)
    photo.tags.inject([]) do |array, tag|
      array << PhotoGroup.find_by_flickr_raw_title(tag.raw)
    end.compact.uniq
  end
end
