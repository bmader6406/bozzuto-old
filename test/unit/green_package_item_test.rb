require 'test_helper'

class GreenPackageItemTest < ActiveSupport::TestCase
  should belong_to(:green_package)
  should belong_to(:green_feature)

  should validate_presence_of(:green_package)
  should validate_presence_of(:green_feature)
  should validate_numericality_of(:savings)
  should validate_numericality_of(:x)
  should validate_numericality_of(:y)
end
