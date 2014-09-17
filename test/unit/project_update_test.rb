require 'test_helper'

class ProjectUpdateTest < ActiveSupport::TestCase
  context 'ProjectUpdate' do
    subject { ProjectUpdate.make }

    should belong_to(:project)

    should validate_presence_of(:body)
    should validate_presence_of(:project)

    should have_attached_file(:image)
  end
end
