module DoubleClickHelper
  # apartment_contact_submissions/thank_you.html.erb
  # apartment_contact_submissions/thank_you.mobile.erb
  # lasso_submissions/thank_you.mobile.erb
  # lasso_submissions/thank_you.mobile.erb
  def double_click_community_thank_you_script(community)
    Analytics::DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'conta168',
      :description => 'Contact Info Complete',
      :fixed_ord   => true).floodlight_tag_script
  end

  # layouts/_head.html.erb (all pages)
  def double_click_community_landing_script
    Analytics::DoubleClick.new(
      :type        => 'ret01',
      :cat         => 'land01',
      :description => 'Landing - Retargeting').floodlight_tag_script
  end

  # apartment_contact_submissions/show.html.erb
  # apartment_contact_submissions/show.mobile.erb
  # lasso_submissions/show.html.erb
  # lasso_submissions/show.mobile.erb
  def double_click_community_request_info_script(community)
    Analytics::DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'reque222',
      :description => 'Request Info').floodlight_tag_script
  end

  # apartment_communities/redesign/_features_and_amenities.html.erb
  # property_pages/features/show.html.erb
  def double_click_community_features_amenities_script(community)
    Analytics::DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'faa01',
      :description => 'Features and Amenities').floodlight_tag_script
  end

  # community_media/index.html.erb
  def double_click_community_photos_videos_script(community)
    Analytics::DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'pav01',
      :description => 'Photos and Videos').floodlight_tag_script
  end

  # apartment_communities/redesign/_floor_plans.html.erb
  # apartment_floor_plan_groups/index.html.erb
  # apartment_floor_plan_groups/index.mobile.erb
  # homes/index.html.erb
  # homes/index.mobile.erb
  def double_click_community_floor_plans_script(community)
    Analytics::DoubleClick.new(
      :name        => community.title,
      :type        => 'conve135',
      :cat         => 'fp01',
      :description => 'Floor Plans').floodlight_tag_script
  end

  # metros/show.html.erb
  # metros/show.mobile.erb
  # areas/show.html.erb (when no amenities filter)
  # areas/show.mobile.erb (when no amenities filter)
  # neighborhoods/show.html.erb (when no amenities filter)
  # neighborhoods/show.mobile.erb (when no amenities filter)
  # home_neighborhoods/show.html.erb
  # home_neighborhoods/show.mobile.erb
  # property_pages/neighborhoods/show.html.erb
  # property_pages/neighborhoods/show.mobile.erb
  def double_click_neighborhood_view_script(neighborhood)
    Analytics::DoubleClick.new(
      :name        => neighborhood.respond_to?(:name) ? neighborhood.name : neighborhood.title,
      :type        => 'conve135',
      :cat         => 'nv01',
      :description => 'Neighborhood View',
      :image       => true).floodlight_tag_script
  end

  # metros/index.html.erb (Find an Apartment page)
  # metros/index.mobile.erb (Find an Apartment page)
  # home_neighborhoods/index.html.erb (Find a New Home page)
  # home_neighborhoods/index.mobile.erb (Find a New Home page)
  def double_click_select_a_neighborhood_script(type)
    Analytics::DoubleClick.new(
      :name        => type,
      :type        => 'conve135',
      :cat         => 'san01',
      :description => 'Select a Neighborhood').floodlight_tag_script
  end

  # When filterer has a current filter..
  # neighborhoods/show.html.erb
  # neighborhoods/show.mobile.erb
  # areas/show.html.erb
  # areas/show.mobile.erb
  def double_click_amenities_filter_script(amenity)
    Analytics::DoubleClick.new(
      :name        => amenity.name,
      :type        => 'conve135',
      :cat         => 'af01',
      :description => 'Amenities Filter',
      :image       => true).floodlight_tag_script
  end

  # email/recently_viewed/thank_you.html.erb
  def double_click_email_thank_you_script(communities)
    titles = communities.map(&:title).reject(&:blank?).join(',')

    Analytics::DoubleClick.new(
      :name        => titles,
      :type        => 'conve135',
      :cat         => 'email947',
      :description => 'Email Results').floodlight_tag_script
  end

  def double_click_data_attrs(name, cat)
    {
      :'data-doubleclick-name' => URI.encode(name),
      :'data-doubleclick-cat'  => cat
    }
  end
end
