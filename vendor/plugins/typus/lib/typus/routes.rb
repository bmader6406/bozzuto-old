module Typus
  class Routes
    # In your application's config/routes.rb, draw Typus's routes:
    #
    # @example
    #   map.resources :posts
    #   Typus::Routes.draw(map)
    #
    # If you need to override a Typus route, invoke your app route
    # earlier in the file so Rails' router short-circuits when it finds
    # your route:
    #
    # @example
    #   map.resources :users, :only => [:new, :create]
    #   Typus::Routes.draw(map)
    def self.draw(router)
      router.instance_eval do
        scope '/admin' do
          match 'quick_edit' => 'typus#quick_edit', :as => :admin_quick_edit
          match '/' => 'typus#dashboard', :as => :admin_dashboard
          match 'sign_in' => 'typus#sign_in', :as => :admin_sign_in
          match 'sign_out' => 'typus#sign_out', :as => :admin_sign_out
          match 'sign_up' => 'typus#sign_up', :as => :admin_sign_up
          match 'recover_password' => 'typus#recover_password', :as => :admin_recover_password
          match 'reset_password' => 'typus#reset_password', :as => :admin_recover_password
        end

        match ':controller(/:action(/:id))', :controller => /admin\/[^\/]+/
        match ':controller(/:action(.:format))', :controller => /admin\/[^\/]+/
      end
    end
  end
end
