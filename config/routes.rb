ActionController::Routing::Routes.draw do |map|
  Typus::Routes.draw(map)
  Jammit::Routes.draw(map)
  Ckeditor::Routes.draw(map)

  map.root :controller => :home_pages

  map.search '/search', :controller => :searches, :action => :index

  map.map_apartment_communities 'apartments/communities/map', :controller => 'apartment_communities', :action => 'index', :template => 'map'


  map.ufollowup 'apartments/communities/:id/ufollowup',
    :controller => 'ufollowup',
    :action     => 'show'
  map.ufollowup_thank_you 'apartments/communities/ufollowup_thank_you',
    :controller => :ufollowup,
    :action     => :thank_you


  community_options = {
    :as          => :communities,
    :only        => [:index, :show],
    :member => {
      :features       => :get,
      :neighborhood   => :get,
      :promotions     => :get,
      :send_to_friend => :post
    }
  }
  map.resources :apartment_communities, community_options.merge(:path_prefix => :apartments) do |community|
    community.resources :floor_plan_groups,
      :controller => :apartment_floor_plan_groups,
      :as         => :floor_plans,
      :only       => :index

    community.resource :info_message, :only => :create # send sms

    community.resource :lead2_lease_submissions,
      :as   => :contact,
      :only => [:show, :create]

    community.resources :media,
      :controller => :community_media,
      :only       => :index
  end


  home_community_options = community_options.merge(
    :path_prefix => 'new-homes',
    :collection  => { :map => :get }
  )
  map.resources :home_communities, home_community_options do |community|
    community.resources :homes, :only => :index

    community.resource :info_message, :only => :create # send sms

    community.resources :media,
      :controller => :community_media,
      :only       => :index
  end

  map.resources :landing_pages, :as => :regions, :only => :show

  map.resource :contact,
    :path_prefix => 'about-us',
    :controller  => :contact_submissions,
    :only        => [:show, :create],
    :member      => { :thank_you => :get }

  map.management_communities '/services/management/communities',
    :controller => :management_communities,
    :section    => 'management'

  map.with_options :controller => :testimonials do |m|
    m.service_section_testimonials '/services/:section/testimonials'
    m.section_testimonials '/:section/testimonials'
  end

  map.with_options :controller => :projects do |m|
    m.service_section_project '/services/:section/our-work/:project_id',
      :action => :show
    m.service_section_projects '/services/:section/our-work'

    m.section_project '/:section/our-work/:project_id',
      :action => :show
    m.section_projects '/:section/our-work'
  end


  ###
  # News & Press
  map.with_options :controller => :news_posts do |m|
    m.service_section_news_post '/services/:section/news-and-press/news/:news_post_id',
      :action => :show
    m.service_section_news_posts '/services/:section/news-and-press/news'

    m.section_news_post '/:section/news-and-press/news/:news_post_id',
      :action => :show
    m.section_news_posts '/:section/news-and-press/news.:format'
  end

  map.with_options :controller => :press_releases do |m|
    m.service_section_press_release '/services/:section/news-and-press/press-releases/:press_release_id',
      :action => :show
    m.service_section_press_releases '/services/:section/news-and-press/press-releases'

    m.section_press_release '/:section/news-and-press/press-releases/:press_release_id',
      :action => :show
    m.section_press_releases '/:section/news-and-press/press-releases'
  end

  map.with_options :controller => :awards do |m|
    m.service_section_award '/services/:section/news-and-press/awards/:award_id',
      :action => :show
    m.service_section_awards '/services/:section/news-and-press/awards'

    m.section_award '/:section/news-and-press/awards/:award_id',
      :action => :show
    m.section_awards '/:section/news-and-press/awards'
  end

  map.with_options :controller => :news_and_press do |m|
    m.service_section_news_and_press '/services/:section/news-and-press',
      :action => :index
    m.section_news_and_press '/:section/news-and-press',
      :action => :index
    m.news_and_press_page '/about-us/news-and-press/*page',
      :section => 'about-us',
      :action => :show
  end


  map.leadership '/:section/leadership', :controller => :leaders, :action => :index

  map.with_options :controller => :buzzes, :section => 'about-us' do |m|
    m.buzz '/bozzuto-buzz', :action => 'new', :conditions => { :method => :get }
    m.create_buzz '/bozzuto-buzz', :action => 'create', :conditions => { :method => :post }
    m.thank_you_buzz '/bozzuto-buzz/thank-you', :action => 'thank_you'
  end

  map.with_options :controller => :pages, :action => :show do |m|
    m.service_section_page '/services/:section/*page'
    m.section_page '/:section/*page'
  end
end
