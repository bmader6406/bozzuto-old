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
          get 'quick_edit' => 'typus#quick_edit', :as => :admin_quick_edit

          get '/' => 'typus#dashboard', :as => :admin_dashboard

          get 'sign_in'  => 'typus#sign_in',  :as => :admin_sign_in
          get 'sign_out' => 'typus#sign_out', :as => :admin_sign_out
          get 'sign_up'  => 'typus#sign_up',  :as => :admin_sign_up

          get 'recover_password' => 'typus#recover_password', :as => :admin_recover_password
          get 'reset_password'   => 'typus#reset_password',   :as => :admin_reset_password
        end

        get ':controller(/:action(/:id))', :controller => /admin\/[^\/]+/
        get ':controller(/:action(.:format))', :controller => /admin\/[^\/]+/
      end
    end
  end
end
