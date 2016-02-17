ActiveAdmin.register ApartmentFloorPlan do
  menu parent: 'Ronin'

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
    column :featured
    column :apartment_community

    actions
  end

  form do |f|
    inputs do
      input :apartment_community
      input :name
      input :featured
      input :image_type, as: :select, collection: ApartmentFloorPlan::IMAGE_TYPE # TODO -- Show/hide URL/Upload
      input :image_url
      input :image
      input :availability_url
      input :available_units
      input :bedrooms
      input :bathrooms
      input :min_square_feet
      input :max_square_feet
      input :min_rent
      input :max_rent
      input :floor_plan_group

      actions
    end
  end
end
