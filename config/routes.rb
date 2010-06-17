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
    service.resources :news, :controller => 'service_news', :only => [:index, :show]
  end

  map.resources :states, :only => :show
end
