class PhotoSet < ActiveRecord::Base
  belongs_to :community, :class_name => 'Community'

  has_many :photos, :order => 'position ASC'

  validates_presence_of :title, :flickr_set_id

  def before_validation
    fetch_set
    set_title
    true
  end

  def validate
    if @set.nil?
      errors.add(:flickr_set_id, 'cannot be found')
    end
  end

  def self.flickr_user
    @user ||= Fleakr.user(APP_CONFIG[:flickr_username])
  end

  def flickr_user
    self.class.flickr_user
  end


  protected

  def fetch_set
    @set = if flickr_set_id.nil?
      nil
    else
      flickr_user.sets.find { |set| set.id == flickr_set_id }
    end
  end

  def set_title
    self.title = @set.try(:title)
  end
end
