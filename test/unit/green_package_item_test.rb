require 'test_helper'

class GreenPackageItemTest < ActiveSupport::TestCase
  should_belong_to(:green_package)
  should_belong_to(:green_feature)

  should_validate_presence_of(:green_package)
  should_validate_presence_of(:green_feature)
  should_validate_numericality_of(:savings)
  should_validate_numericality_of(:x)
  should_validate_numericality_of(:y)
end
