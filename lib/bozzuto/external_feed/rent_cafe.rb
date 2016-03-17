module Bozzuto
  module ExternalFeed
    module RentCafe

      class << self

        def queue!
          ::PropertyFeedImport.create(
            type: type,
            file: ::File.open(Rails.root.join(file_path))
          )
        end

        def imports
          ::PropertyFeedImport.rent_cafe
        end

        def latest
          imports.first
        end

        def file_path
          APP_CONFIG[:rent_cafe_feed_file]
        end

        def type
          "rent_cafe"
        end
      end
    end
  end
end
