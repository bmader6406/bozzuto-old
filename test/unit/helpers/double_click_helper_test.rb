require 'test_helper'

class DoubleClickHelperTest < ActionView::TestCase
  context "#double_click_community_thank_you_script" do
    setup do
      @community = ApartmentCommunity.new(:title => 'Yay Hooray')
    end

    should "return the correct script" do
      script = double_click_community_thank_you_script(@community)

      assert_match /type=conve135/, script
      assert_match /cat=conta168/, script
      assert_match /u1=Yay%20Hooray/, script
      assert_match /Contact Info Complete/, script
      assert_match /ord=1;num='\+ a \+ '\?/, script
    end
  end

  context "#double_click_community_landing_script" do
    should "return the correct script" do
      script = double_click_community_landing_script

      assert_match /type=ret01/, script
      assert_match /cat=land01/, script
      assert_match /Landing - Retargeting/, script
    end
  end

  context "#double_click_community_request_info_script" do
    setup do
      @community = ApartmentCommunity.new(:title => 'Yay Hooray')
    end

    should "return the correct script" do
      script = double_click_community_request_info_script(@community)

      assert_match /type=conve135/, script
      assert_match /cat=reque222/, script
      assert_match /u1=Yay%20Hooray/, script
      assert_match /Request Info/, script
    end
  end

  context "#double_click_community_features_amenities_script" do
    setup do
      @community = ApartmentCommunity.new(:title => 'Yay Hooray')
    end

    should "return the correct script" do
      script = double_click_community_features_amenities_script(@community)

      assert_match /type=conve135/, script
      assert_match /cat=faa01/, script
      assert_match /u1=Yay%20Hooray/, script
      assert_match /Features and Amenities/, script
    end
  end

  context "#double_click_community_photos_videos_script" do
    setup do
      @community = ApartmentCommunity.new(:title => 'Yay Hooray')
    end

    should "return the correct script" do
      script = double_click_community_photos_videos_script(@community)

      assert_match /type=conve135/, script
      assert_match /cat=pav01/, script
      assert_match /u1=Yay%20Hooray/, script
      assert_match /Photos and Videos/, script
    end
  end

  context "#double_click_community_floor_plans_script" do
    setup do
      @community = ApartmentCommunity.new(:title => 'Yay Hooray')
    end

    should "return the correct script" do
      script = double_click_community_floor_plans_script(@community)

      assert_match /type=conve135/, script
      assert_match /cat=fp01/, script
      assert_match /u1=Yay%20Hooray/, script
      assert_match /Floor Plans/, script
    end
  end

  context "#double_click_neighborhood_view_script" do
    setup do
      @neighborhood = Neighborhood.make(:name => 'Yay Hooray')
    end

    should "return the correct script" do
      script = double_click_neighborhood_view_script(@neighborhood)

      assert_match /type=conve135/, script
      assert_match /cat=nv01/, script
      assert_match /u1=Yay%20Hooray/, script
      assert_match /Neighborhood View/, script
      assert_match /<img src/, script
      assert_match /activity;/, script
      assert_match /alt=/, script
    end
  end

  context "#double_click_select_a_neighborhood_script" do
    should "return the correct script" do
      script = double_click_select_a_neighborhood_script('Apartment')

      assert_match /type=conve135/, script
      assert_match /cat=san01/, script
      assert_match /u1=Apartment/, script
      assert_match /Select a Neighborhood/, script
    end
  end

  context "#double_click_amenities_filter_script" do
    setup do
    @amenity = PropertyFeature.make(:name => 'Rapid Transit')
    end

    should "return the correct script" do
      script = double_click_amenities_filter_script(@amenity)

      assert_match /type=conve135/, script
      assert_match /cat=af01/, script
      assert_match /u1=Rapid%20Transit/, script
      assert_match /Amenities Filter/, script
      assert_match /<img src/, script
      assert_match /activity;/, script
      assert_match /alt=/, script
    end
  end

  context "#double_click_email_thank_you_script" do
    setup do
      @community_1 = ApartmentCommunity.new(:title => 'Yay')
      @community_2 = ApartmentCommunity.new(:title => 'Hooray')
    end

    should "return the correct script" do
      script = double_click_email_thank_you_script([@community_1, @community_2])

      assert_match /u1=Yay,Hooray/, script
      assert_match /cat=email947/, script
      assert_match /Email Results/, script
    end
  end

  context "#double_click_data_attrs" do
    should "return the data attrs" do
      attrs = double_click_data_attrs('Yay Hooray', '123')

      assert_equal({
        :'data-doubleclick-name' => 'Yay%20Hooray',
        :'data-doubleclick-cat'  => '123'
      }, attrs)
    end
  end
end
