module Bozzuto
  module SslRequirement
    def self.included(base)
      base.before_filter :ensure_proper_protocol
    end

    private

    #:nocov:
    def ssl_enabled?
      Rails.env.production?
    end
    #:nocov:

    def ssl_required?
      false
    end

    def ensure_proper_protocol
      return true unless ssl_enabled?

      if ssl_required? && !request.ssl?
        redirect_to "https://#{request.host}#{request.fullpath}"
        flash.keep
        return false
      elsif request.ssl? && !ssl_required?
        redirect_to "http://#{request.host}#{request.fullpath}"
        flash.keep
        return false
      end
    end
  end
end
