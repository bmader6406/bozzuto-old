require 'test_helper'

class MediaplexTagTest < ActiveSupport::TestCase
  context 'Mediaplex Tag' do
    should belong_to(:trackable)
  end
end
