require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "ApplicationHelper" do
    describe "#twitter_url" do
      it "returns the twitter url" do
        twitter_url('yaychris').should == 'http://twitter.com/yaychris'
      end
    end

    describe "#render_meta" do
      context "with no prefix" do
        before do
          @page = Page.new(
            :meta_title       => 'Title!',
            :meta_description => 'Description!',
            :meta_keywords    => 'Keywords!'
          )
          expects(:content_for).with(:meta_title, @page.meta_title)
          expects(:content_for).with(:meta_description, @page.meta_description)
          expects(:content_for).with(:meta_keywords, @page.meta_keywords)
        end

        it "sends the data to content_for" do
          render_meta(@page)
        end
      end

      context "with a prefix" do
        before do
          @community = ApartmentCommunity.new(
            :floor_plans_meta_title       => 'Title!',
            :floor_plans_meta_description => 'Description!',
            :floor_plans_meta_keywords    => 'Keywords!'
          )
          expects(:content_for).with(:meta_title, @community.floor_plans_meta_title)
          expects(:content_for).with(:meta_description, @community.floor_plans_meta_description)
          expects(:content_for).with(:meta_keywords, @community.floor_plans_meta_keywords)
        end

        it "sends the data to content_for" do
          render_meta(@community, :floor_plans)
        end
      end
    end

    describe "#bedrooms" do
      it "properly pluralizes the bedrooms count" do
        @plan = ApartmentFloorPlan.new :bedrooms => 1
        bedrooms(@plan).should == '1 Bedroom'

        @plan.bedrooms = 2
        bedrooms(@plan).should == '2 Bedrooms'
      end
    end

    describe "#bathrooms" do
      it "properly pluralizes the bathrooms count" do
        @plan = ApartmentFloorPlan.new :bathrooms => 1
        bathrooms(@plan).should == '1 Bathroom'

        @plan.bathrooms = 2.5
        bathrooms(@plan).should == '2.5 Bathrooms'
      end
    end

    describe "#home?" do
      it "returns true if controller is HomeController" do
        expects(:params).returns(:controller => 'home_pages')

        home?.should == true
      end

      it "returns false otherwise" do
        expects(:params).returns(:controller => 'blah')

        home?.should == false
      end
    end

    describe "#current_if" do
      context "when calling with a hash" do
        before do
          expects(:params).times(3).returns(:controller => 'services', :id => 2)
        end

        it "compares with all items in params" do
          current_if(:controller => 'services').should == 'current'
          current_if(:id => 2).should == 'current'
          current_if(:post => 'hooray').should == nil
        end
      end

      context "when calling with a string" do
        before do
          expects(:params).times(2).returns(:action => 'blah')
        end

        it "compares with the action in params" do
          current_if('blah').should == 'current'
          current_if('booya').should == nil
        end
      end
    end

    describe "#month_and_day" do
      before do
        @date = Time.now
      end
      
      it "returns the marked up date and time" do
        html = HTML::Document.new(month_and_day(@date))
        assert_select html.root, "span.month", "#{@date.strftime('%m')}."
        assert_select html.root, "span.day", "#{@date.strftime('%d')}."
      end

      it "marks the return value HTML safe" do
        month_and_day(@date).should be_html_safe
      end
    end

    describe "#google_maps_javascript_tag" do
      it "returns the script tag" do
        google_maps_javascript_tag.should =~ %r{//maps\.googleapis\.com/maps/api/js\?sensor=false}
      end
    end

    describe "#jmapping" do
      subject { Metro.make }

      it "returns the data attribute with JSON" do
        attr = jmapping(subject)

        attr.should =~ /^data-jmapping='\{.+\}'$/
        attr.should =~ /"id":#{subject.id}/
        attr.should =~ /"category":"Metro"/
        attr.should =~ /"point":\{"lat":#{subject.latitude},"lng":#{subject.longitude}\}/
      end
    end

    describe "#share_this_link" do
      it "outputs p.sharethis and javascript code" do
        sharethis = HTML::Document.new(share_this_link)

        assert_select sharethis.root, 'p.sharethis'
        assert_select sharethis.root, 'script'
      end
    end

    describe "#facebook_like_link" do
      it "outputs div.facebook-like and iframe" do
        facebook = HTML::Document.new(facebook_like_link('http://viget.com'))

        assert_select facebook.root, 'div.facebook-like'
        assert_select facebook.root, 'iframe'
      end
    end

    describe "#facebook_like_box" do
      it "outputs div.facebook-like-box and html/js" do
        code = facebook_like_box('http://facebook.com/batman')

        code.should =~ /data-href="http:\/\/facebook.com\/batman"/m
      end
    end

    describe "#google_plus_one_button" do
      before do
        expects(:content_for).with(:end_of_body, '<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>'.html_safe)
      end

      it "returns the google html tag" do
        google_plus_one_button.should == '<div class="google-plus-one"><g:plusone size="medium"></g:plusone></div>'
      end
    end

    describe "#snippet" do
      context "with missing name" do
        before { @body = snippet(:not_found) }

        it "returns error message" do
          @body.should =~ /This area should be filled in by snippet "not_found,"/
        end
      end

      context "with existing name" do
        before do
          @snippet = Snippet.create :name => 'found', :body => 'hooray'
        end

        should "return the snippet body" do
          snippet(@snippet.name).should == @snippet.body
        end
      end
    end

    describe "#county_apartment_search_path" do
      before { @county = County.make }

      should "return apartment_communities_path with search[county_id]" do
        county_apartment_search_path(@county).should == apartment_communities_path('search[county_id]' => @county.id)
      end
    end

    describe "#county_home_search_path" do
      before { @county = County.make }

      should "return home_communities_path with search[county_id]" do
        county_home_search_path(@county).should == home_communities_path('search[county_id]' => @county.id)
      end
    end

    describe "#community_url" do
      context "with an apartment community" do
        before { @community = ApartmentCommunity.make }

        should "return apartment_community_url" do
          community_url(@community).should == apartment_community_url(@community)
        end
      end

      context "with a home community" do
        before { @community = HomeCommunity.make }

        should "return home_community_url" do
          community_url(@community).should == home_community_url(@community)
        end
      end
    end
  end
end
