class PopulatePropertyTypeOnTablesWithPropertyForeignKey < ActiveRecord::Migration
  def up
    models.each(&:reset_column_information)
    models.flat_map(&:all).each do |record|
      if record.property_id.present?
        property = Property.find_by(id: record.property_id)

        record.update_attribute(:property_type, property.type) if property.present?
      end
    end
  end

  def down
    # no op
  end

  private

  def models
    @models ||= [
      PropertySlideshow,
      PropertyFeaturesPage,
      PropertyNeighborhoodPage,
      PropertyContactPage,
      PropertyToursPage,
      Photo,
      Video,
      BodySlide,
      DnrConfiguration,
      LandingPagePopularOrdering,
      OfficeHour,
      PropertyAmenity
    ]
  end

  Property = Class.new(ActiveRecord::Base)

  class PropertySlideshow < ActiveRecord::Base
    belongs_to :property
  end
  
  class PropertyFeaturesPage < ActiveRecord::Base
    belongs_to :property
  end

  class PropertyNeighborhoodPage < ActiveRecord::Base
    belongs_to :property
  end

  class PropertyContactPage < ActiveRecord::Base
    belongs_to :property
  end

  class PropertyToursPage < ActiveRecord::Base
    belongs_to :property
  end

  class Photo < ActiveRecord::Base
    belongs_to :property
  end

  class Video < ActiveRecord::Base
    belongs_to :property
  end

  class BodySlide < ActiveRecord::Base
    belongs_to :property
  end

  class DnrConfiguration < ActiveRecord::Base
    belongs_to :property
  end

  class LandingPagePopularOrdering < ActiveRecord::Base
    belongs_to :property
  end

  class OfficeHour < ActiveRecord::Base
    belongs_to :property
  end

  class PropertyAmenity < ActiveRecord::Base
    belongs_to :property
  end
end
