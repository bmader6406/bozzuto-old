module Bozzuto
  module SslRequirement
    def self.included(base)
      base.before_filter :ensure_proper_protocol
    end

    private

    def ssl_enabled?
      Rails.env.production?
    end

    def ssl_required?
      false
    end

    def ensure_proper_protocol
      return true unless ssl_enabled?

      if ssl_required? && !request.ssl?
        redirect_to "https://#{request.host}#{request.request_uri}"
        flash.keep
        return false
      elsif request.ssl? && !ssl_required?
        redirect_to "http://#{request.host}#{request.request_uri}"
        flash.keep
        return false
      end
    end
  end
end
