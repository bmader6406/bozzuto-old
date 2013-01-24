require 'test_helper'

class GreenPackageTest < ActiveSupport::TestCase
  subject { GreenPackage.new }

  should_belong_to(:home_community)

  should_validate_presence_of(:home_community)

  should_validate_attachment_presence(:photo)

  context '#home_community_title' do
    setup do
      subject.stubs(:home_community).returns(stub(:title => 'Yay'))
    end

    should "return the home community title" do
      assert_equal 'Yay', subject.home_community_title
    end
  end
end
