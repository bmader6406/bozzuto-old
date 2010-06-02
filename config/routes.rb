ActionController::Routing::Routes.draw do |map|
  Typus::Routes.draw(map)
  Jammit::Routes.draw(map)

  map.resources :communities,
    :only => :show,
    :member => {
      :features     => :get,
      :media        => :get,
      :neighborhood => :get,
      :promotions   => :get,
      :contact      => :get
    }
end
