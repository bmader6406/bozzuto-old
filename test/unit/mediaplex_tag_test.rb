require 'test_helper'

class MediaplexTagTest < ActiveSupport::TestCase
  context 'Mediaplex Tag' do
    should_belong_to :trackable
  end
end
