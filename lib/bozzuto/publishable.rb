module Bozzuto
  module Publishable
    def self.included(base)
      base.class_eval do
        validates_inclusion_of :published, :in => [true, false]

        named_scope :published, :conditions => { :published => true }
        named_scope :latest, lambda { |limit|
          { :limit => limit }
        }
      end
    end
  end
end
