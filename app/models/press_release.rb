class PressRelease < ActiveRecord::Base
  include Bozzuto::Publishable

  default_scope :order => 'published_at DESC'

  has_and_belongs_to_many :sections

  validates_presence_of :title, :body

  def typus_name
    title
  end
end
