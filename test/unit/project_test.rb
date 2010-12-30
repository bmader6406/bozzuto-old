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

    should_validate_presence_of :completion_date
    
    should 'be archivable' do
      assert Project.acts_as_archive?
      assert_nothing_raised do
        Project::Archive
      end
      assert defined?(Project::Archive)
      assert Project::Archive.ancestors.include?(ActiveRecord::Base)
      assert Project::Archive.ancestors.include?(Property::Archive)
    end

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
