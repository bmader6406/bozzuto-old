class DnrConfiguration < ActiveRecord::Base
  belongs_to :property

  validates :property,
            :customer_code,
            presence: true
end
