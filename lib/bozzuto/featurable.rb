module Bozzuto
  module Featurable
    def self.included(base)
      base.class_eval do
        validates_inclusion_of :featured, :in => [true, false]

        scope :featured, :conditions => { :featured => true }
        scope :not_featured, :conditions => { :featured => false }
      end
    end
  end
end
