module Bozzuto
  module Publishable
    def self.included(base)
      base.class_eval do
        validates_inclusion_of :published, :in => [true, false]

        scope :published, -> { where(published: true) }
        scope :latest,    -> (limit) { limit(limit) }
      end
    end
  end
end
