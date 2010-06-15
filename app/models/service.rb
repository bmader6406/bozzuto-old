class Service < ActiveRecord::Base
  acts_as_list

  slugify

  default_scope :order => 'position ASC'

  belongs_to :section

  validates_presence_of :title, :section
  validates_uniqueness_of :title

  def to_param
    slug
  end
end
