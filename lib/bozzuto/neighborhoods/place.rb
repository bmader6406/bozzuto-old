module Bozzuto
  module Neighborhoods
    module Place
      def self.included(base)
        base.class_eval do
          has_friendly_id :name, :use_slug => true

          validates_presence_of :name,
                                :latitude,
                                :longitude

          validates_uniqueness_of :name

          table_name = base.to_s.tableize
          named_scope :positioned,       :order => "#{table_name}.position ASC"
          named_scope :ordered_by_count, :order => "#{table_name}.apartment_communities_count DESC, #{table_name}.name ASC"

          after_save :update_apartment_communities_count
          after_destroy :update_apartment_communities_count

          after_save :invalidate_apartment_floor_plan_cache!
          after_destroy :invalidate_apartment_floor_plan_cache!

          alias_method :floor_plans_for_caching, :available_floor_plans
        end
      end

      def to_s
        name
      end

      def typus_name
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

      def available_floor_plans(reload = false)
        @available_floor_plans = nil if reload

        #:nocov:
        @available_floor_plans ||= begin
        #:nocov:
          ids = communities.map(&:available_floor_plans).flatten.map(&:id)

          ApartmentFloorPlan.scoped(:conditions => { :id => ids })
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

      def update_apartment_communities_count
        if !destroyed?
          self.apartment_communities_count = calculate_apartment_communities_count

          send(:update_without_callbacks)

          reload # Correct count is not persisted w/o this reload
        end

        parent.try(:update_apartment_communities_count)
      end

      protected

      def calculate_apartment_communities_count
        communities(true).count
      end
    end
  end
end
