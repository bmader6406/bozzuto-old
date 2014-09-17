require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context 'Project' do
    setup do
      @project = Project.make
    end

    subject { @project }

    should have_many(:data_points)
    should have_many(:updates)
    should belong_to(:section)
    should have_and_belong_to_many(:project_categories)

    should validate_presence_of(:completion_date)
    
=begin
    should 'be archivable' do
      assert Project.acts_as_archive?
      assert_nothing_raised do
        Project::Archive
      end
      assert defined?(Project::Archive)
      assert Project::Archive.ancestors.include?(ActiveRecord::Base)
      assert Project::Archive.ancestors.include?(Property::Archive)
    end
=end

    context 'in_section named scope' do
      setup do
        @section = Section.make
        @project1 = Project.make :section => @section
      end

      should 'only return projects in the section' do
        assert_equal [@project1], Project.in_section(@section)
      end
    end

    context '#featured_mobile named scope' do
      setup do
        @section = Section.make

        @featured     = Project.make :section => @section, :featured_mobile => true
        @not_featured = Project.make :section => @section, :featured_mobile => false
      end

      should 'return only featured projects' do
        assert_equal [@featured], Project.featured_mobile
      end
    end
  end
end
