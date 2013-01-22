require 'test_helper'

class GreenFeatureTest < ActiveSupport::TestCase
  should_validate_presence_of :title

  should_validate_attachment_presence :photo
end
