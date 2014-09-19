# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.bozzuto.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add careers_path, :changefreq => 'daily'
  add contact_path
  add management_communities_path, :changefreq => 'daily'
  add rankings_path
  add buzzes_path

  add metros_path, :changefreq => 'daily'

  # ApartmentCommunity
  add community_search_path,
      :priority   => 0.9,
      :changefreq => 'daily'
  add map_community_search_path, :changefreq => 'daily'

  ApartmentCommunity.published.featured_order.find_each do |a|
    sitemap_options = { :priority   => 0.6,
                        :changefreq => 'daily',
                        :lastmod    => a.updated_at }

    add apartment_community_path(a),                   sitemap_options.merge({ :priority => 0.9 })
    add apartment_community_floor_plan_groups_path(a), sitemap_options.merge({ :priority => 0.8 })
    add apartment_community_features_path(a),          sitemap_options.merge({ :priority => 0.8 })
    add apartment_community_neighborhood_path(a),      sitemap_options
    add apartment_community_contact_path(a),           sitemap_options
    add apartment_community_media_path(a),             sitemap_options
    add apartment_community_ufollowup_path(a),         sitemap_options.merge({ :priority => 0.5 })
  end

  # HomeCommunity
  add home_communities_path,
      :priority   => 0.9,
      :changefreq => 'daily'
  add map_home_communities_path, :changefreq => 'daily'

  HomeCommunity.published.ordered_by_title.find_each do |h|
    sitemap_options = { :priority   => 0.6,
                        :changefreq => 'daily',
                        :lastmod    => h.updated_at }

    add home_community_path(h),              sitemap_options.merge({ :priority => 0.9 })
    add home_community_homes_path(h),        sitemap_options.merge({ :priority => 0.8 })
    add home_community_features_path(h),     sitemap_options
    add home_community_neighborhood_path(h), sitemap_options
    add home_community_contact_path(h),      sitemap_options
    add home_community_media_path(h),        sitemap_options
  end

  LandingPage.published.find_each do |landing_page|
    add landing_page_path(landing_page),
        :changefreq => 'daily',
        :lastmod    => landing_page.updated_at
  end

  Section.ordered_by_title.find_each do |s|
    add testimonials_path(s),         :lastmod => s.updated_at
    add projects_path(s),             :lastmod => s.updated_at

    s.projects.published.each do |project|
      add project_path(s, project), :lastmod => project.updated_at
    end

    add news_and_press_path(s)
    add news_posts_path(s)

    s.news_posts.published.each do |post|
      add news_post_path(s, post)
    end

    add press_releases_path(s)

    s.press_releases.published.each do |press_release|
      add press_release_path(s, press_release)
    end

    add awards_path(s)

    s.awards.published.each do |award|
      add award_path(s, award)
    end

    s.pages.published.each do |page|
      add page_path(s, page)
    end
  end

  add leaders_path
end
