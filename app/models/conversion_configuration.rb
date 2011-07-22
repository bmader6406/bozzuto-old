class ConversionConfiguration < ActiveRecord::Base
  belongs_to :property

  validates_presence_of :name, :property
end
