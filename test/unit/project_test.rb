require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context 'Project' do
    subject { Project.make }

    should have_many(:data_points)
    should have_many(:updates)

    should have_one(:slideshow)

    should belong_to(:city)
    should belong_to(:section)

    should have_and_belong_to_many(:project_categories)

    should have_attached_file(:listing_image)
    should have_attached_file(:brochure)

    should validate_presence_of(:completion_date)

    describe ".in_section" do
      before do
        @section = Section.make
        @project = Project.make(section: @section)
      end

      it "returns projects in the given section" do
        Project.in_section(@section).should == [@project]
      end
    end

    describe ".featured_mobile" do
      before do
        @section      = Section.make
        @featured     = Project.make(section: @section, featured_mobile: true)
        @not_featured = Project.make(section: @section, featured_mobile: false)
      end

      should "return only featured projects" do
        Project.featured_mobile.should == [@featured]
      end
    end

    describe ".in_categories" do
      before do
        @category = ProjectCategory.make
        @included = Project.make
        @excluded = Project.make

        @included.update_attributes(project_categories: [@category])
      end

      it "returns projects that have the given category" do
        Project.in_categories(@category.id).should == [@included]
      end
    end


    describe ".related_projects" do
      before do
        @section   = Section.make
        @category  = ProjectCategory.make
        @subject   = Project.make(section: @section)
        @unrelated = Project.make(section: @section)
        @project1  = Project.make(section: @section)
        @project2  = Project.make(section: @section)
        @project3  = Project.make(section: @section)
        @project4  = Project.make(section: @section)
        @project5  = Project.make(section: @section)

        @projects = [@subject, @project1, @project2, @project3, @project4, @project5]

        @projects.each do |project|
          project.update_attributes(project_categories: [@category])
        end
      end

      it "returns four projects from the same section with the same categories" do
        @subject.related_projects.should match_array [@project1, @project2, @project3, @project4]
      end

      context "given a limit" do
        it "returns that number of related projects" do
          @subject.related_projects(2).should match_array [@project1, @project2]
        end
      end
    end

    describe "#to_s" do
      it "returns the title" do
        subject.to_s.should == subject.title
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
