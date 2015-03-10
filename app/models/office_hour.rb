class OfficeHour < ActiveRecord::Base
  MERIDIAN_INDICATORS = ['AM', 'PM']

  OPENS_AT_PERIOD  = MERIDIAN_INDICATORS
  CLOSES_AT_PERIOD = MERIDIAN_INDICATORS

  DAY = Date::DAYNAMES.each_with_index.to_a

  belongs_to :property

  validates :property,
            :day,
            :opens_at,
            :opens_at_period,
            :closes_at,
            :closes_at_period,
            :presence => true

  validates :day, :uniqueness => { :scope => :property_id }
  validates :day, :inclusion  => { :in => 0..6 }

  validates :opens_at_period,
            :closes_at_period,
            :inclusion => { :in => MERIDIAN_INDICATORS }

  def day_name
    Date::DAYNAMES[day]
  end

  def to_s
    "#{day_name}: #{opens_at}#{opens_at_period} - #{closes_at}#{closes_at_period}"
  end
end
