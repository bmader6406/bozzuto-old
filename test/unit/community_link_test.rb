require 'test_helper'

class CommunityLinkTest < ActiveSupport::TestCase
  context "A community link" do
    should_belong_to :community

    should_validate_presence_of :title, :url, :community
  end
end
