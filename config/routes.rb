ActionController::Routing::Routes.draw do |map|
  Typus::Routes.draw(map)
  Jammit::Routes.draw(map)

  community_options = {
    :only   => :show,
    :member => {
      :features       => :get,
      :neighborhood   => :get,
      :promotions     => :get,
      :contact        => :get,
      :send_to_friend => :post
    }
  }
  map.resources :communities, community_options do |community|
    community.resources :floor_plan_groups,
      :as   => :floor_plans,
      :only => :index
  end

  map.resources :states, :only => :show

  map.resource :contact,
    :controller => :contact_submissions,
    :only       => [:show, :create],
    :member     => { :thank_you => :get }


  map.with_options :controller => :testimonials do |testimonial|
    testimonial.service_section_testimonials '/services/:section/testimonials'
    testimonial.section_testimonials '/:section/testimonials'
  end

  map.with_options :controller => :news do |news|
    news.service_section_news_post '/services/:section/news/:news_post_id', :action => :show
    news.service_section_news_posts '/services/:section/news'
    news.section_news_post '/:section/news/:news_post_id', :action => :show
    news.section_news_posts '/:section/news'
  end

  map.with_options :controller => :pages, :action => :show do |page|
    page.service_section_page '/services/:section/*pages'
    page.section_page '/:section/*pages'
  end
end
