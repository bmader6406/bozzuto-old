module Bozzuto
  module ExternalFeed
    module Vaultware

      class << self

        def queue!
          ::PropertyFeedImport.create(
            type: type,
            file: ::File.open(Rails.root.join(file_path))
          )
        end

        def imports
          ::PropertyFeedImport.vaultware
        end

        def latest
          imports.first
        end

        def file_path
          APP_CONFIG[:vaultware_feed_file]
        end

        def type
          "vaultware"
        end
      end
    end
  end
end