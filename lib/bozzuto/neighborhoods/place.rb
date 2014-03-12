module Bozzuto
  module Neighborhoods
    module Place
      def self.extended(base)
        base.class_eval do
          extend Bozzuto::Mappable

          has_friendly_id :name, :use_slug => true


          has_attached_file :banner_image,
                            :url             => '/system/:class/:id/:style.:extension',
                            # TODO: determine image dimensions
                            #:styles          => { :square => '150x150#', :rect => '230x145#' },
                            #:default_style   => :square,
                            :convert_options => { :all => '-quality 80 -strip' }

          has_attached_file :listing_image,
                            :url             => '/system/:class/:id/:style.:extension',
                            :styles          => { :resized => '288x237#' },
                            :default_style   => :resized,
                            :convert_options => { :all => '-quality 80 -strip' }

          validates_presence_of :name,
                                :latitude,
                                :longitude

          validates_uniqueness_of :name

          validates_attachment_presence :listing_image

          named_scope :positioned, :order => "#{base.to_s.tableize}.position ASC"

          def to_s
            name
          end
        end
      end
    end
  end
end
