require 'test_helper'

class LeaderTest < ActiveSupport::TestCase
  context "Leader" do
    should_have_many(:leaderships, :dependent => :destroy)

    should_validate_presence_of :name,
                                :title,
                                :company,
                                :bio
  end
end
