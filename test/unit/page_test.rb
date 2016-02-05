require 'test_helper'

class PageTest < ActiveSupport::TestCase
  context "Page" do
    should belong_to(:section)
    should belong_to(:snippet)

    should have_one(:body_slideshow)
    should have_one(:masthead_slideshow)
    should have_one(:carousel)

    should validate_presence_of(:title)
    
    should have_attached_file(:left_montage_image)
    should have_attached_file(:middle_montage_image)
    should have_attached_file(:right_montage_image)
    
=begin
    it "is archivable" do
      assert Page.acts_as_archive?
      assert_nothing_raised do
        Page::Archive
      end
      assert defined?(Page::Archive)
      assert_equal ActiveRecord::Base, Page::Archive.superclass
    end
=end

    describe ".for_sidebar_nav" do
      before do
        @hidden_page  = Page.make :show_in_sidebar_nav => false
        @visible_page = Page.make :show_in_sidebar_nav => true
      end

      it "returns the visible pages" do
        Page.for_sidebar_nav.should include(@visible_page)
      end

      it "doesn't return the hidden pages" do
        Page.for_sidebar_nav.should_not include(@hidden_page)
      end
    end

    describe "#formatted_title" do
      before do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section

        @page2.move_to_child_of(@page1)
      end

      it "returns the formatted string" do
        @page1.formatted_title.should == @page1.title
        @page2.formatted_title.should == "&nbsp;&nbsp;&nbsp;&#8627; #{@page2.title}"
      end
    end

    describe "#first?" do
      before do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
      end

      it "returns true if first" do
        @page1.first?.should == true
      end

      it "returns false otherwise" do
        @page2.first?.should == false
      end
    end

    describe "#root_level?" do
      before do
        @section = Section.make

        @page1 = Page.make(:section => @section)
        @page2 = Page.make(:section => @section)
      end

      subject { @page1 }

      context "there are no ancestors" do
        it "returns true" do
          @page1.root_level?.should == true
        end
      end

      context "there are ancestors" do
        before do
          @page1.move_to_child_of(@page2)
        end

        it "returns false" do
          @page1.root_level?.should == false
        end
      end
    end

    describe "#to_param" do
      before do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
        @page2.move_to_child_of(@page1)
        @page2.save
      end

      it "returns the path" do
        @page1.to_param.should == @page1.slug
        @page2.to_param.should == "#{@page1.slug}/#{@page2.slug}"
      end
    end

    describe "when saving" do
      before do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
        @page2.move_to_child_of(@page1)
        @page2.save
      end

      it "automatically updates the path" do
        @page2.path.should == [@page1.slug, @page2.slug].join('/')
      end
    end
    
    describe "#montage?" do
      before do
        @page = Page.make
      end
      
      context "when all montage images are present" do
        before do
          @page.expects(:left_montage_image?).returns(true)
          @page.expects(:middle_montage_image?).returns(true)
          @page.expects(:right_montage_image?).returns(true)
        end

        it "returns true" do
          @page.montage?.should == true
        end
      end

      context "when any montage images are missing" do
        before do
          @page.expects(:left_montage_image?).returns(false)
          @page.stubs(:middle_montage_image?).returns(true)
          @page.stubs(:right_montage_image?).returns(true)
        end

        it "returns false" do
          @page.montage?.should == false
        end
      end
    end
  end
end
