class PressRelease < ActiveRecord::Base
  include Bozzuto::Publishable
  include Bozzuto::Featurable
  include Bozzuto::Homepage::FeaturableNews

  cattr_reader :per_page
  @@per_page = 15

  has_and_belongs_to_many :sections

  validates :title,
            :body,
            presence: true

  default_scope -> { order(published_at: :desc) }

  def to_s
    title
  end

  def to_label
    to_s
  end
end
