class ConversionConfiguration < ActiveRecord::Base
  belongs_to :property, class_name: 'HomeCommunity'

  validates_presence_of :name, :property
end
