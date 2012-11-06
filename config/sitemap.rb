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
  add buzz_path

  # ApartmentCommunity
  add apartment_communities_path,
      :priority   => 0.9,
      :changefreq => 'daily'
  add map_apartment_communities_path, :changefreq => 'daily'

  ApartmentCommunity.published.featured_order.find_each do |apartment_community|
    sitemap_options = { :priority   => 0.6,
                        :changefreq => 'daily',
                        :lastmod    => apartment_community.updated_at }

    add apartment_community_path(apartment_community),
        sitemap_options.merge({ :priority => 0.9 })

    add apartment_community_floor_plan_groups_path(apartment_community),
        sitemap_options.merge({ :priority => 0.8 })

    add apartment_community_features_path(apartment_community),
        sitemap_options.merge({ :priority => 0.8 })

    add apartment_community_neighborhood_path(apartment_community), sitemap_options
    add apartment_community_contact_path(apartment_community), sitemap_options
    add apartment_community_media_path(apartment_community), sitemap_options
    add ufollowup_path(apartment_community),
        sitemap_options.merge({ :priority => 0.5 })
  end

  # HomeCommunity
  add home_communities_path,
      :priority   => 0.9,
      :changefreq => 'daily'
  add map_home_communities_path, :changefreq => 'daily'

  HomeCommunity.published.ordered_by_title.find_each do |home_community|
    sitemap_options = { :priority   => 0.6,
                        :changefreq => 'daily',
                        :lastmod    => home_community.updated_at }

    add home_community_path(home_community),
        sitemap_options.merge({ :priority => 0.9 })

    add home_community_homes_path(home_community),
        sitemap_options.merge({ :priority => 0.8 })

    add home_community_features_path(home_community), sitemap_options
    add home_community_neighborhood_path(home_community), sitemap_options
    add home_community_contact_path(home_community), sitemap_options
    add home_community_media_path(home_community), sitemap_options
  end

  LandingPage.published.find_each do |landing_page|
    add landing_page_path(landing_page),
        :changefreq => 'daily',
        :lastmod    => landing_page.updated_at
  end

  Section.ordered_by_title.find_each do |section|
    add section_testimonials_path(section), :lastmod => section.updated_at
    add service_section_testimonials_path(section), :lastmod => section.updated_at

    add section_projects_path(section), :lastmod => section.updated_at
    add service_section_projects_path(section), :lastmod => section.updated_at

    section.projects.published.each do |project|
      add section_project_path(section, project), :lastmod => project.updated_at
      add service_section_project_path(section, project), :lastmod => project.updated_at
    end

    add section_news_and_press_path(section)
    add service_section_news_and_press_path(section)

    add service_section_news_posts_path(section)
    add section_news_posts_path(section)

    section.news_posts.published.each do |post|
      add section_news_post_path(section, post)
      add service_section_news_post_path(section, post)
    end

    add service_section_press_releases_path(section)
    add section_press_releases_path(section)

    section.press_releases.published.each do |press_release|
      add section_press_release_path(section, press_release)
      add service_section_press_release_path(section, press_release)
    end

    add section_awards_path(section)
    add service_section_awards_path(section)

    section.awards.published.each do |award|
      add section_award_path(section, award)
      add service_section_award_path(section, award)
    end

    section.pages.published.each do |page|
      add section_page_path(section, page)
      add service_section_page_path(section, page)
    end
  end

  Section.news_and_press.pages.published.each do |page|
    add news_and_press_page_path(page)
  end

  add leadership_path(Section.about)
end
