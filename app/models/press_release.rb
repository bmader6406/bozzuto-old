class PressRelease < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable
  include Bozzuto::Homepage::FeaturableNews

  cattr_reader :per_page
  @@per_page = 15

  default_scope -> { order(published_at: :desc) }

  has_and_belongs_to_many :sections

  validates_presence_of :title, :body

  def typus_name
    title
  end
end
