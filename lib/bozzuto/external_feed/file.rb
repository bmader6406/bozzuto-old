module Bozzuto
  module ExternalFeed
    class File < Bozzuto::ExternalFeed::FeedObject
      attr_accessor :external_cms_id,
                    :external_cms_type,
                    :active,
                    :file_type,
                    :description,
                    :name,
                    :caption,
                    :format,
                    :source,
                    :width,
                    :height,
                    :rank,
                    :ad_id,
                    :affiliate_id

      self.database_attributes = [
        :external_cms_id,
        :external_cms_type,
        :active,
        :file_type,
        :description,
        :name,
        :caption,
        :format,
        :source,
        :width,
        :height,
        :rank,
        :ad_id,
        :affiliate_id
      ]
    end
  end
end
