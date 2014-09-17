module Bozzuto
  module ExternalFeed
    module Model
      def self.included(base)
        base.class_eval do
          class_attribute :external_cms_attributes

          Bozzuto::ExternalFeed::Feed.feed_types.each do |type|
            scope "managed_by_#{type}",
              :conditions => ['external_cms_id IS NOT NULL AND external_cms_type = ?', type]

            define_method "managed_by_#{type}?" do
              external_cms_id.present? && external_cms_type == type
            end
          end

          scope :managed_by_feed, lambda { |cms_id, cms_type|
            { :conditions => ['external_cms_id = ? AND external_cms_type = ?', cms_id, cms_type] }
          }

          scope :managed_locally,
            :conditions => "external_cms_id IS NULL AND (external_cms_type IS NULL OR external_cms_type = '')"

          scope :managed_externally,
            :conditions => "external_cms_type IS NOT NULL AND external_cms_type != ''"
        end
      end

      def managed_externally?
        external_cms_id.present? && external_cms_type.present?
      end

      def external_cms_name
        Bozzuto::ExternalFeed::Feed.feed_name(external_cms_type)
      end
    end
  end
end
