class SeoMetadata < ActiveRecord::Base

  belongs_to :resource, polymorphic: true, inverse_of: :seo_metadata

  validates_presence_of :resource
end
