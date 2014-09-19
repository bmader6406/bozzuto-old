module Bozzuto
  module Test
    module ControllerExtensions
      extend ActiveSupport::Concern

      def login_typus_user(user)
        session[:typus_user_id] = user.id
      end

      def set_mobile!
        @request.env['bozzuto.mobile.device'] = :iphone
      end

      module ClassMethods
        def mobile_device(&block)
          context 'from a mobile device' do
            setup do
              set_mobile!
            end

            context(nil, &block)
          end
        end

        def desktop_device(&block)
          context('from a desktop device', &block)
        end

        def all_devices(&block)
          mobile_device(&block)
          desktop_device(&block)
        end
      end
    end
  end
end

