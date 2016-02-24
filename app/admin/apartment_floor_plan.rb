ActiveAdmin.register ApartmentFloorPlan do
  menu parent: 'Properties'

  permit_params :apartment_community_id,
                :name,
                :featured,
                :image_type,
                :image_url,
                :image,
                :availability_url,
                :available_units,
                :bedrooms,
                :bathrooms,
                :min_square_feet,
                :max_square_feet,
                :min_rent,
                :max_rent,
                :floor_plan_group_id

  filter :name_cont,       label: 'Name'
  filter :bedrooms,        label: 'Bedrooms'
  filter :bathrooms,       label: 'Bathrooms'
  filter :min_square_feet, label: 'Minimum Square Feet'
  filter :max_square_feet, label: 'Maximum Square Feet'
  filter :featured
  filter :apartment_community

  reorderable

  index do
    column :name
    column :bedrooms
    column :bathrooms
    column :square_footage
    column :availability
    column :apartment_community
    column :featured

    actions
  end

  show do |plan|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for plan do
            row :apartment_community
            row :name
            row(:featured) { |plan| plan.featured ? status_tag(:yes) : status_tag(:no) }
            row(:image_type) { |plan| plan.image_type == ApartmentFloorPlan::USE_IMAGE_URL ? 'URL' : 'File' }
            row :image_url
            row :image do |plan|
              if plan.image.present?
                image_tag plan.image.url(:thumb)
              end
            end
            row :availability_url
            row :available_units
            row :bedrooms
            row :bathrooms
            row :min_square_feet
            row :max_square_feet
            row :min_rent
            row :max_rent
            row :floor_plan_group
          end
        end
      end

      tab 'Units' do
        collection_panel_for :apartment_units do
          table_for plan.apartment_units do
            column :name do |unit|
              link_to unit.name, [:new_admin, unit]
            end
            column :bedrooms
            column :bathrooms
            column :square_footage
            column :rent
            column :vacancy_class
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :apartment_community, label: 'Apartment Community'
          input :name
          input :floor_plan_group
          input :bedrooms
          input :bathrooms
          input :min_square_feet
          input :max_square_feet
          input :min_rent
          input :max_rent
          input :image_type, as: :select, collection: ApartmentFloorPlan::IMAGE_TYPE
          input :image_url
          input :image, as: :image
          input :availability_url
          input :available_units
          input :featured
        end

        tab 'Units' do
          association_table_for :apartment_units do
            column :name
            column :bedrooms
            column :bathrooms
            column :square_footage
            column :rent
            column :vacancy_class
          end
        end
      end

      actions
    end
  end
end
