module Bozzuto
  module Neighborhoods
    module Place
      def self.extended(base)
        base.class_eval do
          extend Bozzuto::Mappable

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
          #:nocov:


          protected

          def update_apartment_communities_count
            if !destroyed?
              self.apartment_communities_count = calculate_apartment_communities_count

              send(:update_without_callbacks)
            end

            parent.try(:update_apartment_communities_count)
          end

          #:nocov:
          def calculate_apartment_communities_count
            raise NotImplementedError, "#{self.class} must implemenet #calculate_apartment_communities_count"
          end
          #:nocov:
        end
      end
    end
  end
end
