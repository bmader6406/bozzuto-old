class PhotoSet < ActiveRecord::Base
  before_validation :set_title
  before_save :mark_as_needing_sync

  belongs_to :property
  belongs_to :apartment_community, :foreign_key => :property_id
  belongs_to :home_community, :foreign_key => :property_id
  has_many :photos,
    :order     => 'position ASC',
    :dependent => :destroy

  validates_presence_of :flickr_set_number

  named_scope :needs_sync, :conditions => { :needs_sync => true }


  def validate
    if flickr_set.nil?
      errors.add(:flickr_set_number, 'cannot be found')
    end
  end

  #:nocov:
  def self.flickr_user
    @user ||= Fleakr.user(APP_CONFIG[:flickr]['username'])
  end

  def flickr_user
    self.class.flickr_user
  end

  def sync_photos
    begin
      return false unless flickr_set.present?

      photos.destroy_all

      flickr_set.photos.each do |photo|
        groups = groups_for_photo(photo)

        if groups.any?
          file = choose_size(photo).save_to(RAILS_ROOT + '/tmp')

          self.photos << Photo.new(
            :title           => photo.title,
            :image           => File.open(file.path),
            :flickr_photo_id => photo.id,
            :photo_groups    => groups
          )

          File.delete(file.path)
        end
      end

      self.needs_sync = false
      self.save
    rescue Exception => e
      Rails.logger.debug(e)

      HoptoadNotifier.notify(e)

      false
    end
  end
  #:nocov:

  def flickr_set
    @flickr_set ||= if flickr_set_number.present? && flickr_user.present?
      flickr_user.sets.find { |set| set.id == flickr_set_number }
    end
  end


  protected

  def set_title
    self.title = flickr_set.try(:title)
    true
  end

  #:nocov:
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
  #:nocov:

  def mark_as_needing_sync
    self.needs_sync = true if flickr_set_number_changed?
  end
end
