class Property < ActiveRecord::Base
  belongs_to :city

  validates_presence_of :title, :city
  validates_numericality_of :latitude, :longitude, :allow_nil => true

  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  named_scope :near, lambda { |loc|
    returning({}) do |opts|
      opts[:origin]     = loc
      opts[:conditions] = ['id != ?', loc.id] if loc.is_a?(self)
      opts[:order]      = 'distance ASC'
    end
  }

  def typus_name
    title
  end

  def address
    [street_address, city].compact.join(', ')
  end

  def county
    city.county
  end

  def state
    city.state
  end
end
