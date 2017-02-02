require 'test_helper'

class PressReleaseTest < ActiveSupport::TestCase
  extend AlgoliaSearchable

  context 'A press release' do
    should validate_presence_of(:title)
    should validate_presence_of(:body)

    should have_and_belong_to_many(:sections)

    it_should_behave_like "a featurable news item", PressRelease
    it_should_behave_like "being searchable with algolia", PressRelease, :title

    context '#to_s' do
      setup { @press = PressRelease.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal @press.title, @press.to_s
      end
    end
  end
end
