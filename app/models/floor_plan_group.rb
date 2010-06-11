class FloorPlanGroup < ActiveRecord::Base
  has_many :floor_plans, :dependent => :destroy do
    def cheapest
      rent_field = if proxy_owner.use_market_prices?
        'min_market_rent'
      else
        'min_effective_rent'
      end

      first(:order => "#{rent_field} ASC")
    end

    def largest
      first(:order => 'max_square_feet DESC')
    end
  end

  belongs_to :community

  acts_as_list :scope => :community

  validates_presence_of :name

  def use_market_prices?
    community.try(:use_market_prices?) || false
  end
end
