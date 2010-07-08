class PhotoSet < ActiveRecord::Base
  before_validation :set_title
  after_create :update_photos

  belongs_to :community, :class_name => 'Community'
  has_many :photos, :order => 'position ASC'

  validates_presence_of :title, :flickr_set_id


  def validate
    if flickr_set.nil?
      errors.add(:flickr_set_id, 'cannot be found')
    end
  end

  def self.flickr_user
    @user ||= Fleakr.user(APP_CONFIG[:flickr_username])
  end

  def flickr_user
    self.class.flickr_user
  end

  def update_photos
    if flickr_set.present?
      photos.destroy_all

      flickr_set.photos.each do |photo|
        file = choose_size(photo).save_to(RAILS_ROOT + '/tmp')
        groups = groups_for_photo(photo)

        self.photos << Photo.new(
          :title           => photo.title,
          :image           => File.open(file.path),
          :flickr_photo_id => photo.id,
          :photo_groups    => groups
        )

        File.delete(file.path)
      end
    end
    true
  end

  def flickr_set
    @flickr_set ||= if flickr_set_id.nil?
      nil
    else
      flickr_user.sets.find { |set| set.id == flickr_set_id }
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
