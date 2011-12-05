module Bozzuto
  module Featurable
    def self.included(base)
      base.class_eval do
        validates_inclusion_of :featured, :in => [true, false]

        named_scope :featured, :conditions => { :featured => true }
      end
    end
  end
end
