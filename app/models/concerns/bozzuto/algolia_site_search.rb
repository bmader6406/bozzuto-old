module Bozzuto
  module AlgoliaSiteSearch
    extend ActiveSupport::Concern

    included do
      include AlgoliaSearch
    end

    class_methods do
      def algolia_site_search(options = {}, &block)
        new_block = lambda {
          instance_exec(&block)
          tags do
            tag_list
          end
        }
        algoliasearch DEFAULT_ALGOLIA_OPTIONS.merge(options), &new_block
        acts_as_taggable
      end
    end

    def algolia_id
      "#{self.class.name}#{self.id}"
    end
  end
end
