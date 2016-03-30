module Bozzuto
  module Homepage
    module FeaturableNews
      def self.featurable_news_classes
        @@featurable_news_classes
      end

      def self.featured_news
        featurable_news_classes.map do |klass|
          klass.find_by_show_as_featured_news(true)
        end.compact.first
      end

      def self.included(base)
        @@featurable_news_classes ||= []
        @@featurable_news_classes << base

        base.class_eval do
          has_attached_file :home_page_image,
            :url             => '/system/:class/:id/home_page_image_:style_:id.:extension',
            :styles          => { :normal => '380x150#' },
            :default_style   => :normal,
            :default_url     => '/images/home-latest-news-placeholder.jpg',
            :convert_options => { :all => '-quality 80 -strip' }

          validates_attachment_content_type :home_page_image, content_type: /\Aimage\/.*\Z/

          validates_inclusion_of :show_as_featured_news, :in => [true, false]

          before_save :remove_as_featured_news, :unless => :published?

          after_save :set_only_featured_news, :if => :show_as_featured_news?

          private

          def remove_as_featured_news
            self.show_as_featured_news = false
          end

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
