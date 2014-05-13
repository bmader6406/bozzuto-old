ActionController::Routing::Routes.draw do |map|
  Typus::Routes.draw(map)
  Jammit::Routes.draw(map)
  Ckeditor::Routes.draw(map)
  

  map.root :controller => :home_pages

  map.search '/search',
             :controller => :searches,
             :action     => :index

  map.resource :community_search, :only => :show

  map.map_community_search 'community_searches/map',
                           :controller => :community_searches,
                           :action     => :show,
                           :template   => 'map'

  map.with_options :controller => :careers, :action => :index, :section => 'careers' do |m|
    m.careers '/careers'
    m.connect '/careers/overview'
  end

  map.namespace :email do |email|
    %w(recently_viewed search_results).each do |type|
      email.resource type,
                     :controller => type,
                     :only       => :create,
                     :member     => { :thank_you => :get }
    end

    email.unsubscribe 'unsubscribe/:id',
                      :controller => 'subscriptions',
                      :action     => :destroy
  end



  map.ufollowup 'apartments/communities/:id/ufollowup',
    :controller => 'ufollowup',
    :action     => 'show'
  map.ufollowup_thank_you 'apartments/communities/ufollowup_thank_you',
    :controller => :ufollowup,
    :action     => :thank_you


  # Neighborhoods
  map.with_options :path_prefix => 'apartments/communities' do |m|
    regex = /[-A-Za-z]+(\d+)?/

    m.metros '',
             :controller => :metros,
             :action     => :index

    m.metro ':id',
            :controller   => :metros,
            :action       => :show,
            :requirements => { :id    => regex }

    m.area ':metro_id/:id',
           :controller   => :areas,
           :action       => :show,
           :requirements => { :metro_id => regex, :id => regex }

    m.neighborhood ':metro_id/:area_id/:id',
                   :controller   => :neighborhoods,
                   :action       => :show,
                   :requirements => { :metro_id => regex,
                                      :area_id  => regex,
                                      :id       => regex }
  end

  apartment_community_options = {
    :path_prefix => 'apartments',
    :as          => :communities,
    :only        => :show,
    :member      => { :rentnow => :get }
  }
  map.resources :apartment_communities, apartment_community_options do |community|
    community.resources :floor_plan_groups,
                        :controller => :apartment_floor_plan_groups,
                        :as         => :floor_plans,
                        :only       => :index do |group|

      group.resources :layouts,
                      :controller => :apartment_floor_plans,
                      :only       => [:index, :show]
    end

    community.resource :features,
                       :controller => 'property_pages/features',
                       :only       => :show

    community.resource :neighborhood,
                       :controller => 'property_pages/neighborhoods',
                       :only       => :show

    community.resource :tours,
                       :controller => 'property_pages/tours',
                       :only       => :show

    community.resources :specials,
                        :only       => :index,
                        :controller => :promos

    community.resource :email_listing,
                       :controller => :community_listing_emails,
                       :only       => :create,
                       :member     => { :thank_you => :get }

    community.resource :sms_message,
                       :as     => :send_to_phone,
                       :only   => [:new, :create],
                       :member => { :thank_you => :get }

    community.resource :contact,
                       :controller => :apartment_contact_submissions,
                       :only       => [:show, :create],
                       :member     => { :thank_you => :get }
    
    community.resource :office_hours,
                       :only => :show

    community.resources :media,
                        :controller => :community_media,
                        :only       => :index
  end


  map.resources :green_homes,
                :only        => [:index, :show],
                :path_prefix => 'new-homes',
                :as          => 'green-homes',
                :section     => 'new-homes'

  home_community_options = {
    :path_prefix => 'new-homes',
    :as          => :communities,
    :only        => [:index, :show],
    :collection  => { :map => :get }
  }
  map.resources :home_communities, home_community_options do |community|
    community.resources :homes, :only => :index do |home|
      home.resources :floor_plans,
                     :controller => :home_floor_plans,
                     :only       => [:index, :show]
    end

    community.resource :features,
                       :controller => 'property_pages/features',
                       :only       => :show

    community.resource :neighborhood,
                       :controller => 'property_pages/neighborhoods',
                       :only       => :show

    community.resource :tours,
                       :controller => 'property_pages/tours',
                       :only       => :show

    community.resources :specials,
                        :only       => :index,
                        :controller => :promos

    community.resource :email_listing,
                       :controller => :community_listing_emails,
                       :only       => :create,
                       :member     => { :thank_you => :get }

    community.resource :sms_message,
                       :as     => :send_to_phone,
                       :only   => [:new, :create],
                       :member => { :thank_you => :get }

    community.resource :contact,
                       :controller => :lasso_submissions,
                       :only       => :show,
                       :member     => { :thank_you => :get }
    
    community.resource :office_hours,
                       :only => :show

    community.resources :media,
                        :controller => :community_media,
                        :only       => :index
  end

  map.resources :landing_pages, :as => :regions, :only => :show
  
  map.resources :states, :only => :show do |states|
    states.resources :counties, :only => :index
  end
  map.resources :counties, :only => :show
  map.resources :cities, :only => :show

  map.resource :contact,
    :path_prefix => 'about-us',
    :controller  => :contact_submissions,
    :only        => [:show, :create],
    :member      => { :thank_you => :get }

  map.resources :featured_projects,
    :path_prefix => 'services',
    :as          => 'featured-projects',
    :controller  => :featured_projects,
    :only        => [:index, :show]

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
  map.rankings '/about-us/news-and-press/rankings',
    :controller => :rankings,
    :action     => :index

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

  map.resources :leaders,
                :path_prefix => 'about-us',
                :as          => :leadership,
                :only        => [:index, :show]

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
