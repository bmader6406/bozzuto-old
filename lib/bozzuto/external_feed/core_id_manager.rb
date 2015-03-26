module Bozzuto::ExternalFeed
  class CoreIdManager
    attr_reader :community

    def self.assign_core_ids!
      new.assign_core_ids!
    end

    def self.clear_core_ids!
      new.clear_core_ids!
    end

    def initialize(community = nil)
      @community = community
    end

    def assign_core_ids!
      collection.assign_core_ids!
    end

    def clear_core_ids!
      ApartmentCommunity.update_all(:core_id => nil)
    end

    def assign_id
      return if community.core_id.present?

      core_id = collection(duplicate_communities).core_id_for(community).presence || community.id

      community.update_attributes(:core_id => core_id)
    end

    private

    # The following method walks through a given scope, building a hash keyed off of a community's
    # title.  In this way, communities with matching titles are grouped into an array and wrapped
    # with a SimpleDelegator that adds a #canonical_score that we can then sort by to determine the
    # most # likely candidate to use as our canonical community.  That community's #id_for_export
    # will be used as the #core_id for all communities with the same title.  Example result:
    #
    # {
    #   'Sample Title' => [
    #     <ScoredCommunity canonical_score=1>,
    #     <ScoredCommunity canonical_score=9>,
    #     <ScoredCommunity canonical_score=3>
    #   ],
    #   'Other Title'  => [
    #     <ScoredCommunity canonical_score=3>,
    #     <ScoredCommunity canonical_score=0>
    #   ]
    # }
    #
    def collection(scope = ApartmentCommunity.all)
      @collection ||= scope.reduce(CanonicalCommunityCollection.new) do |collection, community|
        collection.assign_rank(community)
      end
    end

    def duplicate_communities
      ApartmentCommunity.where('title = ? AND id != ?', community.title, community.id)
    end

    class CanonicalCommunityCollection < Hash
      def initialize(default = [])
        super(default)
      end

      def assign_rank(community)
        merge(community.title => self[community.title] << ScoredCommunity.new(community))
      end

      def canonical(community)
        self[community.title].sort_by(&:canonical_score).last
      end

      def core_id_for(community)
        canonical(community).try(:id_for_export)
      end

      def assign_core_ids!
        values.flatten.each do |community|
          community.update_attributes(:core_id => core_id_for(community))
        end
      end
    end

    class ScoredCommunity < SimpleDelegator
      def canonical_score
        core_id_score + included_in_export_score + published_score
      end

      private

      def calculate_score(value)
        yield ? value : 0
      end

      def core_id_score
        calculate_score(5) { core_id.present? }
      end

      def included_in_export_score
        calculate_score(3) { included_in_export? }
      end

      def published_score
        calculate_score(1) { published? }
      end
    end
  end
end
