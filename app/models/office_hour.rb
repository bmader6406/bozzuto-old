class OfficeHour < ActiveRecord::Base
  MERIDIAN_INDICATORS = ['AM', 'PM']

  OPENS_AT_PERIOD  = MERIDIAN_INDICATORS
  CLOSES_AT_PERIOD = MERIDIAN_INDICATORS

  DAY = Date::DAYNAMES.each_with_index.to_a

  belongs_to :property, polymorphic: true

  validates :property,
            :day,
            :presence => true

  validates :opens_at,
            :opens_at_period,
            :closes_at,
            :closes_at_period,
            :presence => true,
            :unless   => :closed?

  validates :day, :uniqueness => { :scope => :property_id }
  validates :day, :inclusion  => { :in => 0..6 }

  validates :opens_at_period,
            :closes_at_period,
            :inclusion => { :in => MERIDIAN_INDICATORS },
            :unless => :closed?

  def day_name
    Date::DAYNAMES[day]
  end

  def opens_at_with_period(separator = ' ')
    if closed?
      'Closed'
    else
      [opens_at, opens_at_period].join(separator)
    end
  end

  def closes_at_with_period(separator = ' ')
    if closed?
      'Closed'
    else
      [closes_at, closes_at_period].join(separator)
    end
  end

  def to_s
    if closed?
      "#{day_name}: Closed"
    else
      "#{day_name}: #{opens_at_with_period('')} - #{closes_at_with_period('')}"
    end
  end
end
