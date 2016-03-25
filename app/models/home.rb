class Home < ActiveRecord::Base

  acts_as_list :scope => :home_community

  belongs_to :home_community

  has_many :floor_plans,
    :class_name => 'HomeFloorPlan',
    :dependent  => :destroy

  accepts_nested_attributes_for :floor_plans, allow_destroy: true

  validates_presence_of :home_community, :bedrooms, :bathrooms
  validates_inclusion_of :featured, :in => [true, false]

  validates_numericality_of :bedrooms, :bathrooms, :minimum => 0
  validates_numericality_of :square_feet,
    :minimum      => 0,
    :only_integer => true,
    :allow_nil    => true

  def to_s
    name
  end

  def diff_attributes
    Chronolog::DiffRepresentation.new(self, includes: :floor_plans).attributes
  end
end
