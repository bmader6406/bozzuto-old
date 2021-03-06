module Bozzuto
  module ExternalFeed
    module Model
      def self.included(base)
        base.class_eval do
          class_attribute :external_cms_attributes

          Bozzuto::ExternalFeed::SOURCES.each do |type|
            scope "managed_by_#{type}", -> { where('external_cms_id IS NOT NULL AND external_cms_type = ?', type) }

            define_method "managed_by_#{type}?" do
              external_cms_id.present? && external_cms_type == type
            end
          end

          scope :managed_by_feed,    -> (cms_id, cms_type) { where('external_cms_id = ? AND external_cms_type = ?', cms_id, cms_type) }
          scope :managed_locally,    -> { where("external_cms_id IS NULL AND (external_cms_type IS NULL OR external_cms_type = '')") }
          scope :managed_externally, -> { where("external_cms_type IS NOT NULL AND external_cms_type != ''") }
        end
      end

      def managed_externally?
        external_cms_id.present? && external_cms_type.present?
      end

      def external_cms_name
        Bozzuto::ExternalFeed.source_name(external_cms_type)
      end
    end
  end
end
