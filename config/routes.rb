Bozzuto::Application.routes.draw do
  Typus::Routes.draw(self)
  Ckeditor::Routes.draw(self)

  # Typus CSV Exports
  get '/admin/under_construction_leads(.:format)', :controller => 'admin/under_construction_leads', :action => :index
  get '/admin/buzzes(.:format)',                   :controller => 'admin/buzzes',                   :action => :index

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
      resource type, :controller => type, :only => :create do
        get 'thank_you', :on => :collection
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
               :path => 'send-to-phone',
               :only => [:new, :create] do
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
    resources :home_communities, :path => 'communities', :only => :show do
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
               :path => 'send-to-phone',
               :only => [:new, :create] do
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
  resources :landing_pages,
            :path => 'regions',
            :only => :show

  resources :states, :only => :show do
    resources :counties, :only => :index
  end

  resources :counties, :only => :show
  resources :cities, :only => :show


  # Buzzes
  match '/bozzuto-buzz', :to => redirect('/bozzuto-buzz/new')

  resources :buzzes,
            :path    => 'bozzuto-buzz',
            :only    => [:new, :create],
            :section => 'about-us' do
    get 'thank_you', :on => :collection
  end


  # About Us
  scope '/about-us', :section => 'about-us' do
    resource :contact_submission,
             :path => 'contact',
             :as   => :contact,
             :only => [:show, :create] do
      get 'thank_you', :on => :member
    end

    resources :leaders,
              :path => 'leadership',
              :only => [:index, :show]

    scope '/news-and-press' do
      resources :rankings, :only => :index
    end
  end


  # Service-specific content
  scope '/services' do
    resources :featured_projects,
              :path => 'featured-projects',
              :only => [:index, :show]

    scope '/management', :section => 'management' do
      resources :management_communities,
                :path => 'communities',
                :only => :index
    end
  end


  # Sections
  # /:section can look like one of the following:
  #
  #   /careers
  #   /services/management
  scope '/:section', :constraints => { :section => %r{(services/)?(-|\w)+} } do
    resources :testimonials, :only => :index

    resources :projects,
              :path => 'our-work',
              :only => [:index, :show]

    scope '/news-and-press' do
      match '/' => 'news_and_press#index', :as => :news_and_press

      resources :awards, :only => [:index, :show]

      resources :news_posts,
                :path => 'news',
                :only => [:index, :show]

      resources :press_releases,
                :path => 'press-releases',
                :only => [:index, :show]
    end

    # Catch-all page route
    match '(*page)' => 'pages#show', :as => :page
  end
end
