require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  context "A photo" do
    should_belong_to :community

    should_validate_presence_of :image, :caption, :community
  end
end
