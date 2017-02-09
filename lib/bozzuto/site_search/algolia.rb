module Bozzuto
  module SiteSearch
    # pulled from alogliasearch-rails AlgoliaSearch::ClassMethods.algolia_search to match behavior there
    module Algolia

      class << self

        def search(q, params = {})
          params[:page] = (params.delete('page') || params.delete(:page)).to_i
          params[:page] -= 1 if params[:page].to_i > 0

          json = raw_search(q, params[:page])

          results = results_for(json)

          setup_paginated_results(results, json)
        end

        private

        def raw_search(q, page)
          AlgoliaSearch::Utilities.get_model_classes.first.algolia_raw_search(q, {page: page})
        end

        def results_for(json)
          json['hits'].map do |hit|
            record = find_hit_record(hit)
            if record
              set_record_hit_meta_info(record, hit)
              record
            end
          end.compact
        end

        def find_hit_record(hit)
          klass, id = hit['objectID'].match(/([A-Za-z]+)(\d+)/)[1,2]
          klass.safe_constantize.try(:find_by_id, id)
        end

        def set_record_hit_meta_info(record, hit)
          record.highlight_result = hit['_highlightResult']
          record.snippet_result = hit['_snippetResult']
        end

        def setup_paginated_results(results, json)
          res = AlgoliaSearch::Pagination.create(results, total_hits_for(json), { :page => json['page'] + 1, :per_page => json['hitsPerPage'] })
          res.extend(AlgoliaSearch::ClassMethods::AdditionalMethods)
          res.extend(PageMethods)
          res.send(:algolia_init_raw_answer, json)
          res
        end

        def total_hits_for(json)
          # Algolia has a default limit of 1000 retrievable hits
          json['nbHits'] < json['nbPages'] * json['hitsPerPage'] ?
            json['nbHits'] : json['nbPages'] * json['hitsPerPage']
        end

      end

      module PageMethods
        def first_result_num
          (current_page * limit_value) - limit_value + 1
        end

        def last_result_num
          [current_page * limit_value, total_count].min
        end
      end

    end
  end
end
