class DnrConfiguration < ActiveRecord::Base
  belongs_to :property

  validates_presence_of :customer_code, :property
end
