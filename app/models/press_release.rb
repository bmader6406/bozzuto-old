class PressRelease < ActiveRecord::Base
  include Bozzuto::Publishable

  default_scope :order => 'published_at DESC'

  validates_presence_of :title, :body
end
