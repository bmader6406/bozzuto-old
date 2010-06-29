ActionController::Routing::Routes.draw do |map|
  Typus::Routes.draw(map)
  Jammit::Routes.draw(map)

  map.root :controller => :home

  community_options = {
    :as          => :communities,
    :path_prefix => :apartments,
    :only        => :show,
    :member => {
      :features       => :get,
      :neighborhood   => :get,
      :promotions     => :get,
      :contact        => :get,
      :send_to_friend => :post
    }
  }
  map.resources :apartment_communities, community_options do |community|
    community.resources :floor_plan_groups,
      :as   => :floor_plans,
      :only => :index
  end

  map.resources :home_communities,
    :as          => :communities,
    :path_prefix => 'new-homes',
    :only        => [:index, :show]

  map.resources :states, :only => :show

  map.resource :contact,
    :path_prefix => :about,
    :controller  => :contact_submissions,
    :only        => [:show, :create],
    :member      => { :thank_you => :get }


  map.with_options :controller => :testimonials do |m|
    m.service_section_testimonials '/services/:section/testimonials'
    m.section_testimonials '/:section/testimonials'
  end

  map.with_options :controller => :projects do |m|
    m.service_section_project '/services/:section/projects/:project_id', :action => :show
    m.service_section_projects '/services/:section/projects'
    m.section_project '/:section/projects/:project_id', :action => :show
    m.section_projects '/:section/projects'
  end

  map.with_options :controller => :news do |m|
    m.service_section_news_post '/services/:section/news/:news_post_id', :action => :show
    m.service_section_news_posts '/services/:section/news'
    m.section_news_post '/:section/news/:news_post_id', :action => :show
    m.section_news_posts '/:section/news.:format'
  end

  map.with_options :controller => :awards do |m|
    m.service_section_award '/services/:section/awards/:award_id', :action => :show
    m.service_section_awards '/services/:section/awards'
    m.section_award '/:section/awards/:award_id', :action => :show
    m.section_awards '/:section/awards'
  end

  map.with_options :controller => :pages, :action => :show do |m|
    m.services '/services', :template => 'services'
    m.service_section_page '/services/:section/*page'
    m.section_page '/:section/*page'
  end
end
