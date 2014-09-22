require 'test_helper'

class BozzutoContentControllerTest < ActiveSupport::TestCase
  context "ContentController" do
    subject { PagesController.new }

    before do
      @section = Section.make

      subject.instance_variable_set(:@section, @section)
    end

    describe "#section_news_posts" do
      before do
        2.times { NewsPost.make :sections => [@section] }
        2.times { NewsPost.make(:unpublished, :sections => [@section]) }
        2.times { NewsPost.make :sections => [Section.make] }
      end

      context "and in the about section" do
        before do
          @section = Section.make(:about)
          subject.instance_variable_set(:@section, @section)
        end

        it "returns all news posts" do
          subject.send(:section_news_posts).should == NewsPost.published
        end
      end

      context "and not in the about section" do
        it "returns this section's news posts" do
          subject.send(:section_news_posts).should == @section.news_posts.published
        end
      end
    end

    describe "#section_testimonials" do
      before do
        2.times { Testimonial.make :section => @section }
        2.times { Testimonial.make :section => Section.make }
      end

      context "and in the about section" do
        before do
          @section = Section.make(:about)
          subject.instance_variable_set(:@section, @section)
        end

        it "returns all testimonials" do
          subject.send(:section_testimonials).should == Testimonial.all
        end
      end

      context "and not in the about section" do
        it "returns this section's testimonials" do
          subject.send(:section_testimonials).should == @section.testimonials
        end
      end
    end

    describe "#section_awards" do
      before do
        2.times { Award.make :sections => [@section] }
        2.times { Award.make(:unpublished, :sections => [@section]) }
        2.times { Award.make :sections => [Section.make] }
      end

      context "and in the about section" do
        before do
          @section = Section.make(:about)
          subject.instance_variable_set(:@section, @section)
        end

        it "returns all awards" do
          subject.send(:section_awards).should == Award.published
        end
      end

      context "and not in the about section" do
        it "returns this section's awards" do
          subject.send(:section_awards).should == @section.awards.published
        end
      end
    end

    describe "#section_projects" do
      before do
        4.times { Project.make :section => @section }
        2.times { Project.make :section => Section.make }
      end

      context "and in the about section" do
        before do
          @section = Section.make(:about)
          subject.instance_variable_set(:@section, @section)
        end

        it "returns this section's projects" do
          subject.send(:section_projects).should == @section.projects.all
        end
      end

      context "and not in the about section" do
        it "returns this section's projects" do
          subject.send(:section_projects).should == @section.projects.all
        end
      end
    end

    describe "#latest_news_posts" do
      before do
        4.times { NewsPost.make :sections => [@section] }
        @posts = subject.send(:latest_news_posts, 2)
      end

      it "returns a limited number of posts" do
        @posts.size.should == 2
        @posts.should == @section.news_posts.published.latest(2).all
      end
    end

    describe "#latest_awards" do
      before do
        4.times { Award.make :sections => [@section] }
        @awards = subject.send(:latest_awards, 2)
      end

      it "returns a limited number of awards" do
        @awards.size.should == 2
        @awards.should == @section.awards.published.latest(2).all
      end
    end
  end
end
