require 'test_helper'

class GreenFeatureTest < ActiveSupport::TestCase
  subject { GreenFeature.make }

  should_have_many(:green_package_items, :dependent => :destroy)

  should_validate_presence_of :title

  should_validate_attachment_presence :photo

  context '#to_s' do
    should 'return the title' do
      assert_equal subject.title, subject.to_s
    end
  end
end
