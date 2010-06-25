require 'test_helper'

class ProjectDataPointTest < ActiveSupport::TestCase
  context 'ProjectDataPoint' do
    setup do
      @point = ProjectDataPoint.make
    end

    subject { @point }

    should_belong_to :project

    should_validate_presence_of :name, :data, :project
  end
end
