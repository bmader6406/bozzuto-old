class PropertyFeature < ActiveRecord::Base

  acts_as_list

  has_and_belongs_to_many :properties

  has_and_belongs_to_many :apartment_communities,
                          :join_table              => 'properties_property_features',
                          :association_foreign_key => :property_id

  has_and_belongs_to_many :home_communities,
                          :join_table              => 'properties_property_features',
                          :association_foreign_key => :property_id

  has_attached_file :icon,
    :url             => '/system/:class/:id/icon_:style.:extension',
    :styles          => { :resized => '44x44#' },
    :default_style   => :resized,
    :convert_options => { :all => '-quality 80 -strip' }

  do_not_validate_attachment_file_type :icon

  validates :name,
            uniqueness: true

  scope :has_icon, -> { where("icon_file_name != ''") }

  def to_s
    name
  end

  def to_label
    to_s
  end
end
