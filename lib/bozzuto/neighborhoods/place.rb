module Bozzuto
  module Neighborhoods
    module Place
      def self.included(base)
        base.class_eval do
          extend FriendlyId

          friendly_id :name, use: [:slugged]

          validates_presence_of :name,
                                :latitude,
                                :longitude

          validates_uniqueness_of :name

          table_name = base.to_s.tableize
          scope :positioned,       -> { order("#{table_name}.position ASC") }
          scope :ordered_by_count, -> { order("#{table_name}.apartment_communities_count DESC, #{table_name}.name ASC") }

          after_save :invalidate_apartment_floor_plan_cache!
          after_destroy :invalidate_apartment_floor_plan_cache!

          alias_method :floor_plans_for_caching, :available_floor_plans
        end
      end

      def to_s
        name
      end

      def full_name
        "#{name} Apartments"
      end

      #:nocov:
      def parent
        raise NotImplementedError, "#{self.class} must implemenet #parent"
      end

      def children
        raise NotImplementedError, "#{self.class} must implemenet #children"
      end
      #:nocov:

      def lineage
        if parent
          parent.lineage + [self]
        else
          [self]
        end
      end

      def lineage_hash
        keys = [:metro, :area, :neighborhood]

        Hash[keys.zip(lineage)].reject { |_, v| v.nil? }
      end

      def communities(reload = false)
        if children.nil?
          apartment_communities(reload).published
        else
          children.map { |c| c.communities(reload) }.flatten.uniq
        end
      end

      def apartment_communities_count
        communities.count
      end

      def has_communities?
        communities.any?
      end

      def available_floor_plans(reload = false)
        @available_floor_plans = nil if reload

        #:nocov:
        @available_floor_plans ||= begin
        #:nocov:
          ids = communities.map(&:available_floor_plans).flatten.map(&:id)

          ApartmentFloorPlan.where(id: ids)
        end
      end

      def name_with_count
        if apartment_communities_count > 0
          "#{name} (#{apartment_communities_count})"
        else
          name
        end
      end

      def as_jmapping
        {
          :id                => id,
          :point             => jmapping_point,
          :category          => jmapping_category,
          :name              => Rack::Utils.escape_html(name),
          :communities_count => apartment_communities_count
        }
      end

      def invalidate_apartment_floor_plan_cache!
        super if !destroyed?

        parent.try(:invalidate_apartment_floor_plan_cache!)
      end
    end
  end
end
