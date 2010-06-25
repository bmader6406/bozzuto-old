require 'test_helper'

class ProjectUpdateTest < ActiveSupport::TestCase
  context 'ProjectUpdate' do
    setup do
      @update = ProjectUpdate.make
    end

    should_belong_to :project

    should_validate_presence_of :body, :project
  end
end
