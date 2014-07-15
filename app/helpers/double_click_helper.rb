module DoubleClickHelper
  # apartment_contact_submissions/thank_you.html.erb
  # apartment_contact_submissions/thank_you.mobile.erb
  # lasso_submissions/thank_you.mobile.erb
  # lasso_submissions/thank_you.mobile.erb
  def double_click_community_thank_you_script(community)
    DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'conta168',
      :description => 'Contact Info Complete',
      :fixed_ord   => true
    ).floodlight_tag_script
  end

  # layouts/_head.html.erb (all pages)
  def double_click_community_landing_script
    DoubleClick.new(
      :type        => 'ret01',
      :cat         => 'land01',
      :description => 'Landing - Retargeting'
    ).floodlight_tag_script
  end

  # apartment_contact_submissions/show.html.erb
  # apartment_contact_submissions/show.mobile.erb
  def double_click_community_request_info_script(community)
    DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'reque222',
      :description => 'Request Info'
    ).floodlight_tag_script
  end

  # apartment_communities/redesign/_features_and_amenities.html.erb
  def double_click_community_features_amenities_script(community)
    DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'faa01',
      :description => 'Features and Amenities'
    ).floodlight_tag_script
  end

  # community_media/index.html.erb
  def double_click_community_photos_videos_script(community)
    DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'pav01',
      :description => 'Photos and Videos'
    ).floodlight_tag_script
  end

  # apartment_communities/redesign/_floor_plans.html.erb
  def double_click_community_floor_plans_script(community)
    DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'fp01',
      :description => 'Floor Plans'
    ).floodlight_tag_script
  end

  # metros/show.html.erb
  # metros/show.mobile.erb
  # areas/show.html.erb (when no amenities filter)
  # areas/show.mobile.erb (when no amenities filter)
  # neighborhoods/show.html.erb (when no amenities filter)
  # neighborhoods/show.mobile.erb (when no amenities filter)
  # home_neighborhoods/show.html.erb
  # home_neighborhoods/show.mobile.erb
  def double_click_neighborhood_view_script(neighborhood)
    DoubleClick.new(
      :name        => neighborhood.name,
      :type        => 'conve135',
      :cat         => 'nv01',
      :description => 'Neighborhood View',
      :image       => true
    ).floodlight_tag_script
  end

  # metros/index.html.erb (Find an Apartment page)
  # metros/index.mobile.erb (Find an Apartment page)
  # home_neighborhoods/index.html.erb (Find a New Home page)
  # home_neighborhoods/index.mobile.erb (Find a New Home page)
  def double_click_select_a_neighborhood_script(type)
    DoubleClick.new(
      :name        => type,
      :type        => 'conve135',
      :cat         => 'san01',
      :description => 'Select a Neighborhood'
    ).floodlight_tag_script
  end

  # When filterer has a current filter..
  # neighborhoods/show.html.erb
  # neighborhoods/show.mobile.erb
  # areas/show.html.erb
  # areas/show.mobile.erb
  def double_click_amenities_filter_script(amenity)
    DoubleClick.new(
      :name        => amenity.name,
      :type        => 'conve135',
      :cat         => 'af01',
      :description => 'Amenities Filter',
      :image       => true
    ).floodlight_tag_script
  end

  # email/recently_viewed/thank_you.html.erb
  def double_click_email_thank_you_script(communities)
    titles = communities.map(&:title).reject(&:blank?).join(',')

    DoubleClick.new(
      :name        => titles,
      :type        => 'conve135',
      :cat         => 'email947',
      :description => 'Email Results'
    ).floodlight_tag_script
  end

  def double_click_data_attrs(name, cat)
    {
      :'data-doubleclick-name' => URI.encode(name),
      :'data-doubleclick-cat'  => cat
    }
  end

  private

  class DoubleClick < Struct.new(:options)
    def floodlight_tag_script
      <<-END.html_safe
        <!--
          Start of DoubleClick Floodlight Tag: Please do not remove
          Activity name of this tag: #{description}
          URL of the webpage where the tag is expected to be placed: http://www.bozzuto.com
          This tag must be placed between the <body> and </body> tags, as close as possible to the opening tag.
          Creation Date: 07/01/2014
        -->

        <script type="text/javascript">
          var axel = Math.random() + "";
          var a = axel * 10000000000000;
          document.write('<#{tag_type} src="http://4076175.fls.doubleclick.net/#{activity_type};src=4076175;#{type}#{cat}#{u1}ord=1;num=' + a + '?" width="1" height="1" #{tag_ending}');
        </script>

        <noscript>
          <#{tag_type} src="http://4076175.fls.doubleclick.net/#{activity_type};src=4076175;#{type}#{cat}#{u1}#{ord}" width="1" height="1" #{tag_ending}
        </noscript>

        <!-- End of DoubleClick Floodlight Tag: Please do not remove -->
      END
    end

    private

    def u1
      "u1=#{property_name};" if property_name
    end

    def cat
      "cat=#{options[:cat]};" if options[:cat]
    end

    def type
      "type=#{options[:type]};" if options[:type]
    end

    def ord
      options[:fixed_ord] ? "ord=1;num='+ a + '?" : "ord='+ a + '?"
    end

    def description
      options[:description]
    end

    def property_name
      URI.encode(options[:name]) if options[:name]
    end

    def image?
      options[:image]
    end

    def tag_type
      image? ? 'img' : 'iframe'
    end

    def activity_type
      image? ? 'activity' : 'activityi'
    end

    def tag_ending
      image? ? "alt=\"\"/>" : "frameborder=\"0\" style=\"display:none\"></iframe>"
    end
  end
end
