require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "ApplicationHelper" do
    context '#twitter_url' do
      should 'return the twitter url' do
        assert_equal 'http://twitter.com/yaychris', twitter_url('yaychris')
      end
    end

    context '#sanitize_phone_number' do
      should 'return just the digits' do
        ['1 (234) 567-8900', '1.234.567.8900', '1 234 567-8900'].each do |number|
          assert_equal '12345678900', sanitize_phone_number(number)
        end
      end
    end

    context '#format_phone_number' do
      context 'with a leading 1' do
        should 'format the phone number' do
          assert_equal '(234) 567-8900', format_phone_number('1.234.567.8900')
        end
      end

      context 'without a leading 1' do
        should 'format the phone number' do
          assert_equal '(234) 567-8900', format_phone_number('234.567.8900')
        end
      end

      context 'with an unknown format' do
        should 'return the number unchanged' do
          number = '+44-20-8123-4567'
          assert_equal number, format_phone_number(number)
        end
      end
    end

    context '#phone_number_uri' do
      context 'with a leading 1' do
        should 'return the tel uri' do
          assert_equal 'tel:+12345678900', phone_number_uri('1 (234) 567-8900')
        end
      end

      context 'without a leading 1' do
        should 'return the tel uri' do
          assert_equal 'tel:+12345678900', phone_number_uri('(234) 567-8900')
        end
      end

      context 'with an unknown format' do
        should 'return the tel uri with the number u' do
          assert_equal 'tel:+442081234567', phone_number_uri('+44-20-8123-4567')
        end
      end
    end

    context '#link_to_phone_number' do
      context 'with a block' do
        should 'generate a link with the phone number URI' do
          link = link_to_phone_number('1 (234) 567-8900', :class => 'yay') { 'Yay!' }

          assert_equal '<a href="tel:+12345678900" class="yay">Yay!</a>', link
        end
      end

      context 'without a block' do
        should 'generate a link with the phone number URI' do
          assert_equal '<a href="tel:+12345678900" class="yay">Yay!</a>',
            link_to_phone_number('Yay!', '1 (234) 567-8900', :class => 'yay')
        end
      end
    end

    context '#dnr_phone_number' do
      context 'with a home community' do
        setup { @community = HomeCommunity.make }

        context 'that has DNR configured' do
          setup do
            @dnr = DnrConfiguration.make_unsaved
            @community.dnr_configuration = @dnr
            @community.save
          end

          should 'output the replaceNumber function call' do
            number  = @community.phone_number.gsub(/\D/, '')
            account = APP_CONFIG[:callsource]['home'].to_s

            assert_match %r{replaceNumber\('#{number}', 'xxx.xxx.xxxx', '#{account}', '#{@dnr.customer_code}', '#{@dnr.campaign}', '#{@dnr.ad_source}'\);},
              dnr_phone_number(@community)
          end
        end

        context 'that does not have a customer code' do
          should 'output the replaceNumber function call' do
            number  = @community.phone_number.gsub(/\D/, '')
            account = APP_CONFIG[:callsource]['home'].to_s

            assert_match %r{replaceNumber\('#{number}', 'xxx.xxx.xxxx', '#{account}', 'undefined', 'undefined', 'undefined'\);},
              dnr_phone_number(@community)
          end
        end
      end

      context 'with an apartment community' do
        setup { @community = ApartmentCommunity.make }

        context 'that has DNR configured' do
          setup do
            @dnr = DnrConfiguration.make_unsaved
            @community.dnr_configuration = @dnr
            @community.save
          end

          should 'output the replaceNumber function call' do
            number  = @community.phone_number.gsub(/\D/, '')
            account = APP_CONFIG[:callsource]['apartment'].to_s

            assert_match %r{replaceNumber\('#{number}', 'xxx.xxx.xxxx', '#{account}', '#{@dnr.customer_code}', '#{@dnr.campaign}', '#{@dnr.ad_source}'\);},
              dnr_phone_number(@community)
          end
        end

        context 'that does not have a customer code' do
          should 'output the replaceNumber function call' do
            number  = @community.phone_number.gsub(/\D/, '')
            account = APP_CONFIG[:callsource]['apartment'].to_s

            assert_match %r{replaceNumber\('#{number}', 'xxx.xxx.xxxx', '#{account}', 'undefined', 'undefined', 'undefined'\);},
              dnr_phone_number(@community)
          end
        end
      end
    end

    context '#render_meta' do
      context 'with no prefix' do
        setup do
          @page = Page.new(
            :meta_title       => 'Title!',
            :meta_description => 'Description!',
            :meta_keywords    => 'Keywords!'
          )
          expects(:content_for).with(:meta_title, @page.meta_title)
          expects(:content_for).with(:meta_description, @page.meta_description)
          expects(:content_for).with(:meta_keywords, @page.meta_keywords)
        end

        should 'send the data to content_for' do
          render_meta(@page)
        end
      end

      context 'with a prefix' do
        setup do
          @community = ApartmentCommunity.new(
            :floor_plans_meta_title       => 'Title!',
            :floor_plans_meta_description => 'Description!',
            :floor_plans_meta_keywords    => 'Keywords!'
          )
          expects(:content_for).with(:meta_title, @community.floor_plans_meta_title)
          expects(:content_for).with(:meta_description, @community.floor_plans_meta_description)
          expects(:content_for).with(:meta_keywords, @community.floor_plans_meta_keywords)
        end

        should 'send the data to content_for' do
          render_meta(@community, :floor_plans)
        end
      end
    end

    context '#bedrooms' do
      should 'properly pluralize the bedrooms count' do
        @plan = ApartmentFloorPlan.new :bedrooms => 1
        assert_equal '1 Bedroom', bedrooms(@plan)

        @plan.bedrooms = 2
        assert_equal '2 Bedrooms', bedrooms(@plan)
      end
    end

    context '#bathrooms' do
      should 'properly pluralize the bathrooms count' do
        @plan = ApartmentFloorPlan.new :bathrooms => 1
        assert_equal '1 Bathroom', bathrooms(@plan)

        @plan.bathrooms = 2.5
        assert_equal '2.5 Bathrooms', bathrooms(@plan)
      end
    end

    context '#home?' do
      should 'return true if controller is HomeController' do
        expects(:params).returns(:controller => 'home_pages')

        assert home?
      end

      should 'return false otherwise' do
        expects(:params).returns(:controller => 'blah')

        assert !home?
      end
    end

    context '#current_if' do
      context 'when calling with a hash' do
        setup do
          expects(:params).times(3).returns(:controller => 'services', :id => 2)
        end

        should 'compare with all items in params' do
          assert_equal 'current', current_if(:controller => 'services')
          assert_equal 'current', current_if(:id => 2)
          assert_nil current_if(:post => 'hooray')
        end
      end

      context 'when calling with a string' do
        setup do
          expects(:params).times(2).returns(:action => 'blah')
        end

        should 'compare with the action in params' do
          assert_equal 'current', current_if('blah')
          assert_nil current_if('booya')
        end
      end
    end

    context '#month_and_day' do
      setup do
        @date = Time.now
      end
      
      should 'return the marked up date and time' do
        html = HTML::Document.new(month_and_day(@date))
        assert_select html.root, "span.month", "#{@date.strftime('%m')}."
        assert_select html.root, "span.day", "#{@date.strftime('%d')}."
      end

      should 'be marked HTML safe' do
        assert month_and_day(@date).html_safe?
      end
    end

    context '#google_maps_javascript_tag' do
      should 'contain the API key' do
        assert_match /#{APP_CONFIG[:google_maps_api_key]}/,
          google_maps_javascript_tag
      end
    end

    context '#share_this_link' do
      should 'output p.sharethis and javascript code' do
        sharethis = HTML::Document.new(share_this_link)

        assert_select sharethis.root, 'p.sharethis'
        assert_select sharethis.root, 'script'
      end
    end

    context '#facebook_like_link' do
      should 'output div.facebook-like and iframe' do
        facebook = HTML::Document.new(facebook_like_link('http://viget.com'))

        assert_select facebook.root, 'div.facebook-like'
        assert_select facebook.root, 'iframe'
      end
    end

    context '#google_plus_one_button' do
      setup do
        expects(:content_for).with(:end_of_body, '<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>'.html_safe)
      end

      should 'return the google html tag' do
        assert_equal '<div class="google-plus-one"><g:plusone size="medium"></g:plusone></div>', google_plus_one_button
      end
    end

    context '#snippet' do
      context 'with missing name' do
        setup { @body = snippet(:not_found) }

        should 'return error message' do
          assert_match /This area should be filled in by snippet "not_found,"/, @body
        end
      end

      context 'with existing name' do
        setup do
          @snippet = Snippet.create :name => 'found', :body => 'hooray'
        end

        should 'return the snippet body' do
          assert_equal @snippet.body, snippet(@snippet.name)
        end
      end
    end

    context '#county_apartment_search_path' do
      setup { @county = County.make }

      should 'return apartment_communities_path with search[county_id]' do
        assert_equal apartment_communities_path('search[county_id]' => @county.id),
          county_apartment_search_path(@county)
      end
    end

    context '#county_home_search_path' do
      setup { @county = County.make }

      should 'return home_communities_path with search[county_id]' do
        assert_equal home_communities_path('search[county_id]' => @county.id),
          county_home_search_path(@county)
      end
    end

    context '#community_url' do
      context 'with an apartment community' do
        setup { @community = ApartmentCommunity.make }

        should 'return apartment_community_url' do
          assert_equal apartment_community_url(@community), community_url(@community)
        end
      end

      context 'with a home community' do
        setup { @community = HomeCommunity.make }

        should 'return home_community_url' do
          assert_equal home_community_url(@community), community_url(@community)
        end
      end
    end
  end
end
