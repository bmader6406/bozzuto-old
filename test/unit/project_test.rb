require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context 'Project' do
    should_have_many :data_points, :updates
    should_belong_to :section
  end
end
