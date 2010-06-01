require 'test_helper'

class CommunityPageTest < ActiveSupport::TestCase
  context "A community page" do
    should_belong_to :community

    should_validate_presence_of :title, :content, :community
  end
end
