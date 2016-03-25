module Bozzuto
  class ReturnToStore

    def initialize(request)
      @request = request
    end

    def get
      session[key]
    end

    def set(val = nil)
      session[key] = val
    end

    def pop
      get.tap { set }
    end

    private

    attr_reader :request

    delegate :session,
             to: :request

    def key
      :return_to
    end
  end
end
