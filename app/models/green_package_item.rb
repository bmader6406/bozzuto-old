class GreenPackageItem < ActiveRecord::Base
  acts_as_list :scope => :green_package


  belongs_to :green_package,
             :inverse_of => :green_package_items

  belongs_to :green_feature,
             :inverse_of => :green_package_items


  validates_presence_of :green_package, :green_feature

  validates_numericality_of :savings, :greater_than_or_equal_to => 0

  validates_numericality_of :x, :y,
                            :integer_only             => true,
                            :greater_than_or_equal_to => 0

  validates_inclusion_of :optional, :in => [true, false]
end
