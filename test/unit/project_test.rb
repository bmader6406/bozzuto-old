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

    describe "#short_description" do
      context "when the project has a short description" do
        before { subject.short_description = 'So short' }

        it "returns the short description" do
          subject.short_description.should == 'So short'
        end
      end

      context "when the project does not have a short description" do
        context "but has project categories" do
          before do
            subject.project_categories << ProjectCategory.make(:title => 'Shib')
            subject.project_categories << ProjectCategory.make(:title => 'Stahp')
            subject.project_categories << ProjectCategory.make(:title => 'Wow')
          end

          it "returns the first two categories split by a forward slash" do
            subject.short_description.should == 'Shib / Stahp'
          end
        end

        context "or project categories" do
          it "returns an empty string" do
            subject.short_description.should == ''
          end
        end
      end
    end

    describe "#project?" do
      it "returns true" do
        subject.project?.should == true
      end
    end

    describe "#apartment_community?" do
      it "returns false" do
        subject.apartment_community?.should == false
      end
    end

    describe "#home_community?" do
      it "returns false" do
        subject.home_community?.should == false
      end
    end
  end
end
