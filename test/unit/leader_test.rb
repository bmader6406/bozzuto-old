require 'test_helper'

class LeaderTest < ActiveSupport::TestCase
  context "Leader" do
    should_validate_presence_of :name, :title, :company, :leadership_group, :bio
    should_belong_to :leadership_group
  end
end
