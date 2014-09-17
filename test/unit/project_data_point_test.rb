require 'test_helper'

class ProjectDataPointTest < ActiveSupport::TestCase
  context 'ProjectDataPoint' do
    subject { ProjectDataPoint.make }

    should belong_to(:project)

    should validate_presence_of(:name)
    should validate_presence_of(:data)
    should validate_presence_of(:project)
  end
end
