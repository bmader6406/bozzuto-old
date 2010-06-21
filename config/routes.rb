ActionController::Routing::Routes.draw do |map|
  Typus::Routes.draw(map)
  Jammit::Routes.draw(map)

  map.resources :communities,
    :only => :show,
    :member => {
      :features       => :get,
      :neighborhood   => :get,
      :promotions     => :get,
      :contact        => :get,
      :send_to_friend => :post
    } do |community|
    community.resources :floor_plan_groups,
      :as => :floor_plans,
      :only => :index
  end

  map.resources :services, :only => [:index, :show] do |service|
  end

  map.resources :states, :only => :show

  map.resource :contact,
    :controller => :contact_submissions,
    :only       => [:show, :create],
    :member     => { :thank_you => :get }


  map.with_options :controller => :testimonials do |map|
    map.service_testimonials '/services/:section/testimonials'

    map.testimonials '/:section/testimonials'
  end

  map.with_options :controller => :news do |map|
    map.service_news_posts '/services/:section/news'
    map.service_news_post '/services/:section/news/:news_post_id', :action => :show

    map.news_posts '/:section/news'
    map.news_post '/:section/news/:news_post_id', :action => :show
  end
end
