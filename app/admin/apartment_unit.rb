ActiveAdmin.register ApartmentUnit do
  menu parent: 'Ronin'

  permit_params :floor_plan_id,
                :marketing_name,
                :organization_name,
                :unit_type,
                :bedrooms,
                :bathrooms,
                :min_square_feet,
                :max_square_feet,
                :square_foot_type,
                :unit_rent,
                :market_rent,
                :min_rent,
                :max_rent,
                :avg_rent,
                :economic_status,
                :economic_status_description,
                :occupancy_status,
                :occupancy_status_description,
                :leased_status,
                :leased_status_description,
                :number_occupants,
                :floor_plan_name,
                :phase_name,
                :building_name,
                :primary_property_id,
                :address_line_1,
                :address_line_2,
                :city,
                :state,
                :zip,
                :comment,
                :vacate_date,
                :vacancy_class,
                :made_ready_date,
                :availability_url,
                amenities_attributes: [
                  :id,
                  :apartment_unit_id,
                  :primary_type,
                  :sub_type,
                  :description,
                  :_destroy
                ],
                feed_files_attributes: [
                  :id,
                  :apartment_unit_id,
                  :file_type,
                  :format,
                  :name,
                  :source,
                  :description,
                  :caption,
                  :width,
                  :height,
                  :ad_id,
                  :rank,
                  :affiliate_id,
                  :active,
                  :_destroy
                ]

  filter :external_cms_id_or_marketing_name_cont, label: 'Name'
  filter :bedrooms,                               label: 'Bedrooms'
  filter :bathrooms,                              label: 'Bathrooms'
  filter :min_square_feet,                        label: 'Minimum Square Feet'
  filter :max_square_feet,                        label: 'Maximum Square Feet'
  filter :min_rent_or_market_rent_or_unit_rent,   label: 'Rent', as: :numeric
  filter :vacancy_class,                          label: 'Vacancy Status', as: :select, collection: ApartmentUnit::VACANCY_CLASS

  index do
    column :name
    column :bedrooms
    column :bathrooms
    column :square_footage
    column :rent
    column :vacancy_class do |unit|
      if unit.vacancy_class.present?
        value = unit.vacancy_class == ApartmentUnit::VACANCY_CLASS.first ? :no : :yes

        status_tag(unit.vacancy_class, value)
      end
    end
    column :apartment_community

    actions
  end

  form do |f|
    inputs do
      tabs do
        tab 'Main' do
          input :marketing_name
          input :organization_name
          input :unit_type
          input :floor_plan
          input :floor_plan_name
          input :bedrooms
          input :bathrooms
          input :min_square_feet
          input :max_square_feet
          input :square_foot_type
          input :phase_name
          input :building_name
          input :primary_property_id
          input :comment
        end

        tab 'Rent' do
          input :unit_rent
          input :market_rent
          input :min_rent
          input :max_rent
          input :avg_rent
        end

        tab 'Status' do
          input :economic_status
          input :economic_status_description
          input :occupancy_status
          input :occupancy_status_description
          input :leased_status
          input :leased_status_description
          input :number_occupants
          input :vacate_date, as: :datepicker
          input :vacancy_class, as: :select, collection: ApartmentUnit::VACANCY_CLASS
          input :made_ready_date, as: :datepicker
          input :availability_url
        end

        tab 'Address' do
          input :address_line_1
          input :address_line_2
          input :city
          input :state
          input :zip
        end

        tab 'Amenities' do
          has_many :amenities, allow_destroy: true, new_record: 'Add Amenity', heading: false do |amenity|
            amenity.input :primary_type, as: :select, collection: ApartmentUnitAmenity::PRIMARY_TYPE
            amenity.input :sub_type, as: :select, collection: ApartmentUnitAmenity::SUB_TYPE
            amenity.input :description
          end
        end

        tab 'Feed Files' do
          has_many :feed_files, allow_destroy: true, new_record: false, heading: false do |file|
            file.input :file_type, as: :select, collection: FeedFile::FILE_TYPE
            file.input :format
            file.input :name
            file.input :source
            file.input :description
            file.input :caption
            file.input :width
            file.input :height
            file.input :ad_id
            file.input :rank
            file.input :affiliate_id
            file.input :active
          end
        end
      end

      actions
    end
  end
end
