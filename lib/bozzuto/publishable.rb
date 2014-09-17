module Bozzuto
  module Publishable
    def self.included(base)
      base.class_eval do
        validates_inclusion_of :published, :in => [true, false]

        scope :published, :conditions => { :published => true }
        scope :latest, lambda { |limit|
          { :limit => limit }
        }
      end
    end
  end
end
