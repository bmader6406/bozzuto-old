module Bozzuto
  module Test
    module IntegrationExtensions
      protected

      # Get the full path and expiration date from the cookies header
      def full_cookies
        HashWithIndifferentAccess.new.tap do |hash|
          @response.headers['Set-Cookie'].split("\n").each do |cookie|
            key = nil

            details = cookie.split(';').inject(HashWithIndifferentAccess.new) do |fields, cookie_field|
              pair = cookie_field.split('=').map { |val|
                Rack::Utils.unescape(val.strip)
              }

              key = pair.first unless key

              fields.merge(pair.first => pair.last)
            end

            if details['expires']
              details['expires'] = Time.parse(details['expires'])
            end

            hash[key] = details
          end
        end
      end
    end
  end
end

