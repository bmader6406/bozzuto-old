module Bozzuto
  module ExternalCMS
    EXTERNAL_CMS_TYPES = %w(vaultware property_link)

    def self.included(base)
      base.class_eval do
        EXTERNAL_CMS_TYPES.each do |type|
          named_scope "managed_by_#{type}",
            :conditions => ['external_cms_id IS NOT NULL AND external_cms_type = ?', type]

          define_method "managed_by_#{type}?" do
            external_cms_id.present? && external_cms_type == type
          end
        end

        named_scope :managed_by_feed, lambda { |cms_id, cms_type|
          { :conditions => ['external_cms_id = ? AND external_cms_type = ?', cms_id, cms_type] }
        }
      end
    end
  end
end
