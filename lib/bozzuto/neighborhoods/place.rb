module Bozzuto
  module Neighborhoods
    module Place
      def self.included(base)
        base.class_eval do
          has_friendly_id :name, :use_slug => true


          has_attached_file :banner_image,
                            :url             => '/system/:class/:id/banner_:style.:extension',
                            :styles          => { :resized => '1020x325#' },
                            :default_style   => :resized,
                            :convert_options => { :all => '-quality 80 -strip' }

          validates_presence_of :name,
                                :latitude,
                                :longitude

          validates_uniqueness_of :name

          table_name = base.to_s.tableize
          named_scope :positioned,       :order => "#{table_name}.position ASC"
          named_scope :ordered_by_count, :order => "#{table_name}.apartment_communities_count DESC, #{table_name}.name ASC"

          after_save :update_apartment_communities_count
          after_destroy :update_apartment_communities_count
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

      def communities(reload = false)
        children.map { |c| c.communities(reload) }.flatten.uniq
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
          :id                          => id,
          :point                       => jmapping_point,
          :category                    => jmapping_category,
          :name                        => name,
          :apartment_communities_count => apartment_communities_count
        }
      end


      protected

      def update_apartment_communities_count
        if !destroyed?
          self.apartment_communities_count = calculate_apartment_communities_count

          send(:update_without_callbacks)
        end

        parent.try(:update_apartment_communities_count)
      end

      def calculate_apartment_communities_count
        communities(true).count
      end
    end
  end
end
