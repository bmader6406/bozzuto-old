require 'test_helper'

class PropertiesHelperTest < ActionView::TestCase
  context "PropertiesHelper" do
    context '#brochure_link' do
      setup do
        @link_text = 'Click me'
        @property = Property.new :brochure_link_text => @link_text
      end

      context 'when the property has no brochure_link_text' do
        should 'return nil' do
          assert_nil brochure_link(@property)
        end
      end

      context 'when the property uses brochure url' do
        setup do
          @url = 'http://viget.com'
          @property.brochure_url = @url
        end

        should 'return a link with the brochure url' do
          link = HTML::Document.new(brochure_link(@property))
          assert_select link.root, 'a',
            :href => @url,
            :text => @link_text
        end
      end

      context 'when the property uses brochure file' do
        setup do
          @file = 'http://viget.com/file.jpg'
          @property.brochure_type = Property::USE_BROCHURE_FILE
          @property.brochure = mock()
          @property.brochure.expects(:url).returns(@file)
        end

        should 'return a link with the brochure file url' do
          link = HTML::Document.new(brochure_link(@property))
          assert_select link.root, 'a',
            :href => @file,
            :text => @link_text
        end
      end
    end

    context 'icons' do
      context "#property_icons" do
        setup do
          @community = ApartmentCommunity.make
          3.times { @community.property_features << PropertyFeature.make }
        end

        should "emit icons for the community's features" do
          icons = HTML::Document.new(property_icons(@community))

          assert_select icons.root, "ul.community-icons"

          @community.property_features.each do |feature|
            assert_select icons.root, "a",
              :href => "##{dom_id(feature)}",
              :text => feature.name
          end
        end
      end

      context "#property_icon_descriptions" do
        setup do
          3.times { PropertyFeature.make }
          @features = PropertyFeature.all
        end

        should "emit icons for the community's features" do
          icons = HTML::Document.new(property_icon_descriptions)

          assert_select icons.root, "ul#icon-tooltips"

          @features.each do |feature|
            assert_select icons.root, "li##{dom_id(feature)}"
            assert_select icons.root, "li h4", feature.name
          end
        end
      end
    end

    context "#property_bullets" do
      setup do
        @bullet_1 = 'Here is some bullet 1 text'
        @bullet_2 = 'Bullet 2 text'
        @community = ApartmentCommunity.make(
          :overview_bullet_1 => @bullet_1,
          :overview_bullet_2 => @bullet_2
        )
      end

      should "emit icons for true flags on the community" do
        bullets = HTML::Document.new(property_bullets)
        assert_select bullets.root, 'li', :count => 2
        assert_select bullets.root, 'li', :text => @bullet_1
        assert_select bullets.root, 'li', :text => @bullet_2
      end
    end

    context '#send_to_phone_mediaplex_code' do
      setup do
        @time = Time.new
        Time.stubs(:new).returns(@time)
      end

      context 'with an apartment community' do
        setup do
          @community = ApartmentCommunity.make
          @mediaplex_id = CGI.escape("#{@community.id}-#{@time.to_i}")
        end

        should 'return the correct iframe' do
          code = send_to_phone_mediaplex_code(@community)

          assert_match /Apartments_Send_to_Phone/, code
          assert_match /#{@community.id}-#{@time.to_i}/, code
        end
      end

      context 'with a home community' do
        setup do
          @community = HomeCommunity.make
          @mediaplex_id = CGI.escape("#{@community.id}-#{@time.to_i}")
        end

        should 'return the correct iframe' do
          code = send_to_phone_mediaplex_code(@community)

          assert_match /Bozzuto_Homes_Send_To_Phone/, code
          assert_match /#{@mediaplex_id}/, code
        end
      end
    end

    context '#send_to_friend_mediaplex_code' do
      setup do
        @email        = Faker::Internet.email
        @time         = Time.new
        @mediaplex_id = CGI.escape("#{@email}-#{@time.to_i}")

        Time.stubs(:new).returns(@time)
      end

      context 'with an apartment community' do
        setup { @community = ApartmentCommunity.make }

        should 'return the correct iframe' do
          code = send_to_friend_mediaplex_code(@community, @email)

          assert_match /Apartments_Send_to_Friend/, code
          assert_match /#{@mediaplex_id}/, code
        end
      end

      context 'with a home community' do
        setup { @community = HomeCommunity.make }

        should 'return the correct iframe' do
          code = send_to_friend_mediaplex_code(@community, @email)

          assert_match /Bozzuto_Homes_Send_To_Friend/, code
          assert_match /#{@mediaplex_id}/, code
        end
      end
    end

    context '#send_me_updates_mediaplex_code' do
      setup do
        @time = Time.new
        Time.stubs(:new).returns(@time)
      end

      context 'with an email address' do
        setup do
          @email        = Faker::Internet.email
          @mediaplex_id = CGI.escape("#{@email}-#{@time.to_i}")
        end

        should 'return the correct iframe' do
          code = send_me_updates_mediaplex_code(@email)

          assert_match /Apartments_Send_Me_Updates/, code
          assert_match /mpuid=#{@mediaplex_id}/, code
        end
      end

      context 'without an email address' do
        setup do
          @email        = nil
          @mediaplex_id = CGI.escape("#{@time.to_i}")
        end

        should 'return the correct iframe' do
          code = send_me_updates_mediaplex_code(@email)

          assert_match /Apartments_Send_Me_Updates/, code
          assert_match /mpuid=#{@mediaplex_id}/, code
        end
      end
    end

    context '#home_contact_form_mediaplex_code' do
      setup do
        @community = HomeCommunity.make
        @time = Time.new
        Time.stubs(:new).returns(@time)
      end

      context 'with an email address' do
        setup do
          @email        = Faker::Internet.email
          @mediaplex_id = CGI.escape("#{@community.id}-#{@email}-#{@time.to_i}")
        end

        should 'return the correct iframe' do
          code = home_contact_form_mediaplex_code(@community, @email)

          assert_match /Bozzuto_Homes_Lead/, code
          assert_match /mpuid=#{@mediaplex_id}/, code
        end
      end

      context 'without an email address' do
        setup do
          @email        = nil
          @mediaplex_id = CGI.escape("#{@community.id}-#{@time.to_i}")
        end

        should 'return the correct iframe' do
          code = home_contact_form_mediaplex_code(@community, @email)

          assert_match /Bozzuto_Homes_Lead/, code
          assert_match /mpuid=#{@mediaplex_id}/, code
        end
      end
    end
  end
end
