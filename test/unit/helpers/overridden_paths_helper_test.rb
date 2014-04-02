require 'test_helper'

class OverriddenPathsHelperTest < ActionView::TestCase
  context 'OverriddenPathsHelper' do
    setup do
      @section = Section.make
      @service = Section.make(:service)
    end

    context '#page_path' do
      context 'when section is a service' do
        setup { @page = Page.make(:section => @service) }

        should 'return the service path' do
          assert_equal service_section_page_path(@service, @page),
            page_path(@service, @page)
        end
      end

      context 'when section is not a service' do
        setup { @page = Page.make(:section => @section) }

        should 'return the section path' do
          assert_equal section_page_path(@section, @page),
            page_path(@section, @page)
        end
      end
    end

    context '#awards_path' do
      context 'when section is a service' do
        should 'return the service path' do
          assert_equal service_section_awards_path(@service),
            awards_path(@service)
        end
      end

      context 'when section is not a service' do
        should 'return the section path' do
          assert_equal section_awards_path(@section),
            awards_path(@section)
        end
      end
    end

    context '#award_path' do
      context 'when section is a service' do
        setup { @award = Award.make(:sections => [@service]) }

        should 'return the service path' do
          assert_equal service_section_award_path(@service, @award),
            award_path(@service, @award)
        end
      end

      context 'when section is not a service' do
        setup { @award = Award.make(:sections => [@section]) }

        should 'return the section path' do
          assert_equal section_award_path(@section, @award),
            award_path(@section, @award)
        end
      end
    end

    context '#projects_path' do
      context 'when section is a service' do
        should 'return the service path' do
          assert_equal service_section_projects_path(@service),
            projects_path(@service)
        end
      end

      context 'when section is not a service' do
        should 'return the section path' do
          assert_equal section_projects_path(@section),
            projects_path(@section)
        end
      end
    end

    context '#project_path' do
      context 'when section is a service' do
        setup { @project = Project.make(:section => @service) }

        should 'return the service path' do
          assert_equal service_section_project_path(@service, @project),
            project_path(@service, @project)
        end
      end

      context 'when section is not a service' do
        setup { @project = Project.make(:section => @section) }

        should 'return the section path' do
          assert_equal section_project_path(@section, @project),
            project_path(@section, @project)
        end
      end
    end

    context '#news_posts_path' do
      context 'when section is a service' do
        should 'return the service path' do
          assert_equal service_section_news_posts_path(@service),
            news_posts_path(@service)
        end
      end

      context 'when section is not a service' do
        should 'return the section path' do
          assert_equal section_news_posts_path(@section),
            news_posts_path(@section)
        end
      end
    end

    context '#news_post_path' do
      context 'when section is a service' do
        setup { @post = NewsPost.make(:sections => [@service]) }

        should 'return the service path' do
          assert_equal service_section_news_post_path(@service, @post),
            news_post_path(@service, @post)
        end
      end

      context 'when section is not a service' do
        setup { @post = NewsPost.make(:sections => [@section]) }

        should 'return the section path' do
          assert_equal section_news_post_path(@section, @post),
            news_post_path(@section, @post)
        end
      end
    end

    context '#press_releases_path' do
      context 'when section is a service' do
        should 'return the service path' do
          assert_equal service_section_press_releases_path(@service),
            press_releases_path(@service)
        end
      end

      context 'when section is not a service' do
        should 'return the section path' do
          assert_equal section_press_releases_path(@section),
            press_releases_path(@section)
        end
      end
    end

    context '#press_release_path' do
      context 'when section is a service' do
        setup { @press = PressRelease.make(:sections => [@service]) }

        should 'return the service path' do
          assert_equal service_section_press_release_path(@service, @press),
            press_release_path(@service, @press)
        end
      end

      context 'when section is not a service' do
        setup { @press = PressRelease.make(:sections => [@section]) }

        should 'return the section path' do
          assert_equal section_press_release_path(@section, @press),
            press_release_path(@section, @press)
        end
      end
    end

    context '#news_and_press_path' do
      context 'when section is a service' do
        should 'return the service path' do
          assert_equal service_section_news_and_press_path(@service),
            news_and_press_path(@service)
        end
      end

      context 'when section is not a service' do
        should 'return the section path' do
          assert_equal section_news_and_press_path(@section),
            news_and_press_path(@section)
        end
      end
    end

    context '#testimonials_path' do
      context 'when section is a service' do
        should 'return the service path' do
          assert_equal service_section_testimonials_path(@service),
            testimonials_path(@service)
        end
      end

      context 'when section is not a service' do
        should 'return the section path' do
          assert_equal section_testimonials_path(@section),
            testimonials_path(@section)
        end
      end
    end

    context '#property_path' do
      context "when property is ApartmentCommunity" do
        setup do
          @property = ApartmentCommunity.make
        end

        should 'return the property' do
          assert_equal apartment_community_path(@property), property_path(@property)
        end
      end

      context "when property is HomeCommunity" do
        setup do
          @property = HomeCommunity.make
        end

        should 'return the property' do
          assert_equal home_community_path(@property), property_path(@property)
        end
      end

      context 'when property is Project' do
        setup do
          @project = Project.make(:section => @section)
        end

        should 'return project_path' do
          assert_equal project_path(@project.section, @project),
            property_path(@project)
        end
      end
    end

    %w(url path).each do |type|
      context "#contact_community_#{type}" do
        context 'when community is an ApartmentCommunity' do
          setup { @community = ApartmentCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("apartment_community_contact_#{type}", @community),
              send("contact_community_#{type}", @community)
          end
        end

        context 'when community is a HomeCommunity' do
          setup { @community = HomeCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("home_community_contact_#{type}", @community),
              send("contact_community_#{type}", @community)
          end
        end
      end

      context "#schedule_tour_community_#{type}" do
        context "on a community with a schedule_tour_url set" do
          setup do
            @community = ApartmentCommunity.make({
              :schedule_tour_url => 'http://www.example.com/tour'
            })
          end

          should "return the correct tour link" do
            assert_equal 'http://www.example.com/tour',
              send("schedule_tour_community_#{type}", @community)
          end
        end

        context 'when community is an ApartmentCommunity' do
          setup { @community = ApartmentCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("apartment_community_contact_#{type}", @community),
              send("schedule_tour_community_#{type}", @community)
          end
        end

        context 'when community is a HomeCommunity' do
          setup { @community = HomeCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("home_community_contact_#{type}", @community),
              send("schedule_tour_community_#{type}", @community)
          end
        end
      end
    end

    context '#section_contact_path' do
      context 'when section has a contact topic' do
        setup { ContactTopic.make :section => @section }

        should 'return the service path with topic set' do
          assert_equal contact_path(:topic => @section.contact_topic),
            section_contact_path(@section)
        end
      end

      context 'when section does not have a contact topic' do
        should 'return the section path' do
          assert_equal contact_path, section_contact_path(@section)
        end
      end
    end

    describe "#place_path" do
      before do
        @neighborhood = Neighborhood.make
        @area         = @neighborhood.area
        @metro        = @area.metro
      end

      context "place is a metro" do
        it "returns the path" do
          place_path(@metro).should == metro_path(@metro)
        end
      end

      context "place is an area" do
        it "returns the path" do
          place_path(@area).should == area_path(@metro, @area)
        end
      end

      context "place is a neighborhood" do
        it "returns the path" do
          place_path(@neighborhood).should == neighborhood_path(@metro, @area, @neighborhood)
        end
      end
    end
  end
end
