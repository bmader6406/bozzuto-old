module Bozzuto
  module Seo
    def self.extended(base)
      base.class_eval do
        has_one :seo_metadata, as: :resource, dependent: :destroy

        accepts_nested_attributes_for :seo_metadata

        delegate :meta_title,
                 :meta_description,
                 :meta_keywords,
                 to: :seo_metadata, allow_nil: true
      end
    end
  end
end
