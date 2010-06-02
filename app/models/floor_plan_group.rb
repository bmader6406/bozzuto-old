class FloorPlanGroup < ActiveRecord::Base
  has_many :floor_plans do
    def cheapest
      first(:order => 'price ASC')
    end

    def largest
      first(:order => 'square_feet DESC')
    end
  end

  belongs_to :community

  acts_as_list :scope => :community

  validates_presence_of :name
end
