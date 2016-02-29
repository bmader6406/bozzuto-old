ActiveAdmin.register PropertyAmenity do
  menu false

  permit_params :property,
                :property_id,
                :primary_type,
                :sub_type,
                :description,
                :position

  filter :primary_type, as: :select, collection: PropertyAmenity::PRIMARY_TYPE

  index do
    column :property
    column :primary_type
    column :description

    actions
  end

  form do |f|
    inputs do
      input :property
      input :primary_type, collection: PropertyAmenity::PRIMARY_TYPE
      input :sub_type,     collection: PropertyAmenity::SUB_TYPE
      input :description
    end

    actions
  end
end
