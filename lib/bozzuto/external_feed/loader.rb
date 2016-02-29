module Bozzuto
  module ExternalFeed
    class Loader
      include LoadingProcess

      allow_loading_every 2.hours

      def self.loader_for_type(type, opts = {})
        opts.assert_valid_keys(:file)

        identify_loading_process_as type

        new(Bozzuto::ExternalFeed::Feed.feed_for_type(type, opts[:file]))
      end

      attr_accessor :feed

      delegate :feed_name, :feed_type, :loading_enabled?, :to => :feed

      def initialize(feed)
        @feed = feed
      end

      def process_identifier
        feed_type
      end

      def file=(new_file)
        feed.file = new_file
      end

      def load!
        run_load_process { feed.process }
      end
    end
  end
end
