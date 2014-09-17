Bozzuto::Application.routes.draw do
  #Typus::Routes.draw(map)
  #Ckeditor::Routes.draw(map)


  root :to => 'home_pages#index'


  # Searching
  match '/search' => 'searches#index', :as => :search

  resource :community_search, :only => :show

  match '/community_searches/map' => 'community_searches#show',
        :as                       => :map_community_search,
        :template                 => 'map'


  # Careers
  match '/careers' => 'careers#index', :section => 'careers'

  match '/careers/overview' => redirect('/careers')


  # Emails
  namespace :email do
    %w(recently_viewed search_results).each do |type|
      resource type, :only => :create do
        get 'thank_you', :on => :member
      end
    end

    match 'unsubscribe/:id' => 'subscriptions#destroy',
          :as               => :unsubscribe
  end


  scope '/apartments' do
    scope '/communities' do
      match 'ufollowup_thank_you' => 'ufollowup#thank_you',
            :as                   => :ufollowup_thank_you


      # Neighborhoods
      regex = /[-A-Za-z]+(\d+)?/

      match '/' => 'metros#index', :as => :metros

      match ':id'        => 'metros#show',
            :as          => :metro,
            :constraints => { :id => regex }

      match ':metro_id/:id' => 'areas#show',
            :as             => :area,
            :constraints    => { :metro_id => regex, :id => regex }

      match ':metro_id/:area_id/:id' => 'neighborhoods#show',
            :as                      => :neighborhood,
            :constraints             => { :metro_id => regex, :area_id => regex, :id => regex }
    end

    resources :apartment_communities, :path => 'communities', :only => [:show] do
      get 'rentnow', :on => :member


      resources :apartment_floor_plan_groups, :path => 'floor_plan_groups',
                :as   => :floor_plan_groups,
                :only => :index do

        resources :apartment_floor_plans, :path => 'layouts',
                  :as   => :layouts,
                  :only => [:index, :show]
      end

      resource :features,
               :controller => 'property_pages/features',
               :only       => :show

      resource :neighborhood,
               :controller => 'property_pages/neighborhoods',
               :only       => :show

      resource :tours,
               :controller => 'property_pages/tours',
               :only       => :show

      resources :specials,
                :only       => :index,
                :controller => :promos

      resource :email_listing,
               :controller => :community_listing_emails,
               :only       => :create do
        get :thank_you, :on => :member
      end

      resource :sms_message,
               :as     => :send_to_phone,
               :only   => [:new, :create] do
        get :thank_you, :on => :member
      end

      resource :contact,
               :controller => :apartment_contact_submissions,
               :only       => [:show, :create] do
        get :thank_you, :on => :member
      end

      resource :office_hours, :only => :show

      resources :media,
                :controller => :community_media,
                :only       => :index

      resource :ufollowup,
               :controller => :ufollowup,
               :only       => [:show, :create]
    end
  end


  # Green homes
  scope '/new-homes' do
    resources :green_homes,
              :path => 'green-homes',
              :only => [:index, :show]

    scope '/communities' do
      # Home Neighborhoods
      regex = /[-A-Za-z]+(\d+)?/

      match '/' => 'home_neighborhoods#index',
            :as => :home_neighborhoods

      match ':id' => 'home_neighborhoods#show',
            :as => :home_neighborhood,
            :constraints => { :id => regex }
    end

    # Home communities
    resources :home_communities, :path => 'communities', :only => [:index, :show] do
      get :map, :on => :collection

      resources :homes, :only => :index do
        resources :floor_plans,
                  :controller => :home_floor_plans,
                  :only       => [:index, :show]
      end

      resource :features,
               :controller => 'property_pages/features',
               :only       => :show

      resource :neighborhood,
               :controller => 'property_pages/neighborhoods',
               :only       => :show

      resource :tours,
               :controller => 'property_pages/tours',
               :only       => :show

      resources :specials,
                :only       => :index,
                :controller => :promos

      resource :email_listing,
               :controller => :community_listing_emails,
               :only       => :create do
        get :thank_you, :on => :member
      end

      resource :sms_message,
               :as     => :send_to_phone,
               :only   => [:new, :create] do
        get :thank_you, :on => :member
      end

      resource :contact,
               :controller => :lasso_submissions,
               :only       => :show do
        get :thank_you, :on => :member
      end

      resource :office_hours, :only => :show

      resources :media,
                :controller => :community_media,
                :only       => :index
    end
  end


  # Geography
  resources :landing_pages, :as => :regions, :only => :show

  resources :states, :only => :show do
    resources :counties, :only => :index
  end
  resources :counties, :only => :show
  resources :cities, :only => :show


  # Contact
  scope '/about-us' do
    resource :contact_submission, :path => 'contact', :as => :contact, :only => [:show, :create] do
      get 'thank_you', :on => :member
    end
  end


  # Management Communities
  scope '/services' do
    match 'management/communities', :to => 'management_communities#index', :section => 'management'

    resources :featured_projects,
              :path => 'featured-projects',
              :only => [:index, :show]
  end


  # Testimonials
  scope '/services/:section' do
    resources :testimonials,
              :as   => :service_section_testimonials,
              :only => :index
  end

  scope '/:section' do
    resources :testimonials,
              :as   => :section_testimonials,
              :only => :index
  end


  # Projects
  scope '/services/:section' do
    resources :projects,
              :path => 'our-work',
              :as   => :service_section_projects,
              :only => [:index, :show]
  end

  scope '/:section' do
    resources :projects,
              :path => 'our-work',
              :as   => :section_projects,
              :only => [:index, :show]
  end


  # Rankings
  scope '/about-us/news-and-press' do
    resources :rankings, :only => :index
  end


  # News Posts
  scope '/services/:section/news-and-press' do
    resources :news_posts,
              :path => 'news',
              :as   => :service_section_news_posts,
              :only => [:index, :show]
  end

  scope '/:section/news-and-press' do
    resources :news_posts,
              :path => 'news',
              :as   => :section_news_posts,
              :only => [:index, :show]
  end


  # Press Releases
  scope '/services/:section/news-and-press' do
    resources :press_releases,
              :path => 'press-releases',
              :as   => :service_section_press_releases,
              :only => [:index, :show]
  end

  scope '/:section/news-and-press' do
    resources :press_releases,
              :path => 'press-releases',
              :as   => :section_press_releases,
              :only => [:index, :show]
  end


  # Awards
  scope '/services/:section/news-and-press' do
    resources :awards,
              :as   => :service_section_awards,
              :only => [:index, :show]
  end

  scope '/:section/news-and-press' do
    resources :awards,
              :as   => :section_awards,
              :only => [:index, :show]
  end


  # News & Press
  scope '/services/:section' do
    match 'news-and-press' => 'news_and_press#index',
          :as              => :service_section_news_and_press
  end

  scope '/:section' do
    match 'news-and-press' => 'news_and_press#index',
          :as              => :section_news_and_press
  end

  scope '/about-us/news-and-press' do
    match '*page'  => 'news_and_press#show',
          :as      => :news_and_press_page,
          :section => 'about-us'
  end


  # Leaders
  scope '/about-us' do
    resources :leaders,
              :as   => :leadership,
              :only => [:index, :show]
  end



  # Buzzes
  match '/bozzuto-buzz', :to => redirect('/bozzuto-buzz/new')

  resources :buzzes,
            :path    => 'bozzuto-buzz',
            :only    => [:new, :create],
            :section => 'about-us' do
    get 'thank_you', :on => :collection
  end


  scope '/services/:section' do
    match '(*page)' => 'pages#show',
          :as       => :service_section_page
  end

  scope '/:section' do
    match '(*page)' => 'pages#show',
          :as       => :section_page
  end
end
