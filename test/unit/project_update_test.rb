require 'test_helper'

class ProjectUpdateTest < ActiveSupport::TestCase
  context 'ProjectUpdate' do
    setup { @update = ProjectUpdate.make }

    should_belong_to :project

    should_validate_presence_of :body, :project

    should_have_attached_file :image
  end
end
