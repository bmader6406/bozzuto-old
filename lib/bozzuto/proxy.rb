module Bozzuto
  class Proxy
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

    def initialize(target)
      @_target = target
    end


    protected

    def method_missing(name, *args, &block)
      @_target.send(name, *args, &block)
    end
  end
end
