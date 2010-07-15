require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context 'Project' do
    setup do
      @project = Project.make
    end

    subject { @project }

    should_have_many :data_points, :updates
    should_belong_to :section
    should_have_and_belong_to_many :project_categories

    context 'in_section named scope' do
      setup do
        @section = Section.make
        @project1 = Project.make :section => @section
      end

      should 'only return projects in the section' do
        assert_equal [@project1], Project.in_section(@section)
      end
    end
  end
end
