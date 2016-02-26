# TODO fix these imports, modernization, RF- 2-1-16
require 'typus/routes'
require 'rails-ckeditor/lib/ckeditor'

Bozzuto::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  Typus::Routes.draw(self)
  Ckeditor::Routes.draw(self)

  # TODO This namespace will change once Typus is removed.
  namespace :new_admin do
    resource :home_page, only: [:show, :update], controller: :home_page
  end

  # Typus CSV Exports
  get '/admin/under_construction_leads(.:format)', :controller => 'admin/under_construction_leads', :action => :index
  get '/admin/buzzes(.:format)',                   :controller => 'admin/buzzes',                   :action => :index
  get '/admin/ad_sources(.:format)',               :controller => 'admin/ad_sources',               :action => :index

  root :to => 'home_pages#index'

  # Searching
  get '/search' => 'searches#index', :as => :search

  resource :community_search, :only => :show

  get '/community_searches/map' => 'community_searches#show',
      :as                       => :map_community_search,
      :template                 => 'map'


  # Careers
  get '/careers' => 'careers#index', :section => 'careers'

  get '/careers/:page' => redirect('/careers'), :constraints => { :page => /overview.*/ }

  # Emails
  namespace :email do
    %w(recently_viewed search_results).each do |type|
      resource type, :controller => type, :only => :create do
        get 'thank_you', :on => :collection
      end
    end

    get 'unsubscribe/:id' => 'subscriptions#destroy', :as => :unsubscribe
  end

  scope '/apartments' do
    scope '/communities' do
      get 'ufollowup_thank_you' => 'ufollowup#thank_you', :as => :ufollowup_thank_you

      # Neighborhoods
      regex = /[-A-Za-z]+(\d+)?/

      get '/' => 'metros#index', :as => :metros

      get ':id'        => 'metros#show',
            :as          => :metro,
            :constraints => { :id => regex }

      get ':metro_id/:id' => 'areas#show',
            :as             => :area,
            :constraints    => { :metro_id => regex, :id => regex }

      get ':metro_id/:area_id/:id' => 'neighborhoods#show',
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

      resource :retail,
               :controller => 'property_pages/retail',
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

      get '/' => 'home_neighborhoods#index',
            :as => :home_neighborhoods

      get ':id' => 'home_neighborhoods#show',
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
  get '/bozzuto-buzz', :to => redirect('/bozzuto-buzz/new')

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
             :only => :show do
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
  scope '/:section', :constraints => SectionConstraint.new  do
    resources :testimonials, :only => :index

    resources :projects,
              :path => 'our-work',
              :only => [:index, :show]

    scope '/news-and-press' do
      get '/' => 'news_and_press#index', :as => :news_and_press

      resources :awards, :only => [:index, :show]

      resources :news_posts,
                :path => 'news',
                :only => [:index, :show]

      resources :press_releases,
                :path => 'press-releases',
                :only => [:index, :show]
    end

    # Catch-all page route
    get '(*page)' => 'pages#show', :as => :page
  end
end
