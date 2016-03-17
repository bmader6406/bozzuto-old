module Bozzuto
  module ExternalFeed
    module PropertyLink

      class << self

        def queue!
          ::PropertyFeedImport.create(
            type: type,
            file: ::File.open(Rails.root.join(file_path))
          )
        end

        def imports
          ::PropertyFeedImport.property_link
        end

        def latest
          imports.first
        end

        def file_path
          APP_CONFIG[:property_link_feed_file]
        end

        def type
          "property_link"
        end
      end
    end
  end
end
