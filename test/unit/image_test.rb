require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  context "Image" do
    should have_attached_file(:image)

    should validate_presence_of(:image)
  end
end
