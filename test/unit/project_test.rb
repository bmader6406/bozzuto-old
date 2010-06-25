require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context 'Project' do
    should_belong_to :section
  end
end
