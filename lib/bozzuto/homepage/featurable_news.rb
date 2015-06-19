module Bozzuto
  module Homepage
    module FeaturableNews
      @@featurable_news_classes ||= [
        Award,
        NewsPost,
        PressRelease
      ]

      def self.included(base)
        base.class_eval do
          validates_inclusion_of :show_as_featured_news, :in => [true, false]

          after_save :set_only_featured_news, :if => :show_as_featured_news?

          private

          def set_only_featured_news
            @@featurable_news_classes.each do |klass|
              scope = klass == self.class ? klass.where("id != ?", id) : klass

              scope.update_all(:show_as_featured_news => false)
            end
          end
        end
      end
    end
  end
end
