module Typus
  module MasterControllerExtensions
    def self.included(base)
      base.prepend_before_filter :ensure_proper_protocol
    end

    private

    def ssl_required?
      true
    end
  end
end
