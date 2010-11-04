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
      [ApartmentCommunity, HomeCommunity].each do |klass|
        context "when property is #{klass}" do
          setup do
            @property = klass.make
          end

          should 'return the property' do
            assert_equal @property, property_path(@property)
          end
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

    context '#send_to_friend_path' do
      context "when property is HomeCommunity" do
        setup { @property = HomeCommunity.make }

        should 'return the send_to_friend_home_community_path' do
          assert_equal home_community_send_to_friend_submissions_path(@property),
            send_to_friend_path(@property)
        end
      end

      context "when property is ApartmentCommunity" do
        setup { @property = ApartmentCommunity.make }

        should 'return the send_to_friend_apartment_community_path' do
          assert_equal apartment_community_send_to_friend_submissions_path(@property),
            send_to_friend_path(@property)
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

    context '#send_me_updates_path' do
      context "when property is HomeCommunity" do
        setup { @property = HomeCommunity.make }

        should 'return the send_to_friend_home_community_path' do
          assert_equal home_community_sms_message_path(@property),
            send_me_updates_path(@property)
        end
      end

      context "when property is ApartmentCommunity" do
        setup { @property = ApartmentCommunity.make }

        should 'return the send_to_friend_apartment_community_path' do
          assert_equal apartment_community_sms_message_path(@property),
            send_me_updates_path(@property)
        end
      end
    end
  end
end
