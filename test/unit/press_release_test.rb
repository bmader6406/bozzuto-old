require 'test_helper'

class PressReleaseTest < ActiveSupport::TestCase
  context 'A press release' do
    should_validate_presence_of :title, :body
  end
end
