require 'test_helper'

class PressReleaseTest < ActiveSupport::TestCase
  context 'A press release' do
    should validate_presence_of(:title)
    should validate_presence_of(:body)

    should have_and_belong_to_many(:sections)

    it_should_behave_like "a featurable news item", PressRelease

    context '#typus_name' do
      setup { @press = PressRelease.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal @press.title, @press.typus_name
      end
    end
  end
end
