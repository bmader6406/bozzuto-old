class FloorPlanGroup < ActiveRecord::Base
  has_many :floor_plans do
    def cheapest
      first(:order => 'min_market_rent ASC')
    end

    def largest
      first(:order => 'max_square_feet DESC')
    end
  end

  belongs_to :community

  acts_as_list :scope => :community

  validates_presence_of :name
end
