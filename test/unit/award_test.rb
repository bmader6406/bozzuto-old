require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  context 'Award' do
    should validate_presence_of(:title)

    should have_and_belong_to_many(:sections)

    should have_attached_file(:image)

    context '#typus_name' do
      setup { @award = Award.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal @award.title, @award.typus_name
      end
    end
  end
end
