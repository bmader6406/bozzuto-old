class DnrConfiguration < ActiveRecord::Base
  belongs_to :property, polymorphic: true

  validates :property,
            :customer_code,
            presence: true
end
