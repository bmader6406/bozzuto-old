require 'test_helper'

class PressReleaseTest < ActiveSupport::TestCase
  context 'A press release' do
    should_validate_presence_of :title, :body

    should_have_and_belong_to_many :sections

    context '#typus_name' do
      setup { @press = PressRelease.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal @press.title, @press.typus_name
      end
    end
  end
end
