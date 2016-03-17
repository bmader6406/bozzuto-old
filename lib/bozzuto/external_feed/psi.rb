module Bozzuto
  module ExternalFeed
    module Psi

      class << self

        def queue!
          ::PropertyFeedImport.create(
            type: type,
            file: ::File.open(Rails.root.join(file_path))
          )
        end

        def imports
          ::PropertyFeedImport.psi
        end

        def latest
          imports.first
        end

        def file_path
          APP_CONFIG[:psi_feed_file]
        end

        def type
          "psi"
        end
      end
    end
  end
end
