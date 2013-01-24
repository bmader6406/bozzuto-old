require 'test_helper'

class GreenFeatureTest < ActiveSupport::TestCase
  should_have_many(:green_package_items, :dependent => :destroy)

  should_validate_presence_of :title

  should_validate_attachment_presence :photo
end
