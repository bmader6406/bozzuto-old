class Page < ActiveRecord::Base
  acts_as_nested_set :scope => :section

  has_friendly_id :title, :use_slug => true

  belongs_to :section
end
