require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  context 'Award' do
    should validate_presence_of(:title)

    should have_and_belong_to_many(:sections)

    should have_attached_file(:image)

    it_should_behave_like "a featurable news item", Award

    context '#to_s' do
      setup { @award = Award.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal 'Hey ya', @award.to_s
      end
    end
  end
end
