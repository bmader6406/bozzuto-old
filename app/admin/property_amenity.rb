ActiveAdmin.register PropertyAmenity do
  menu false

  permit_params :property,
                :property_id,
                :property_type,
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

  show do |amenity|
    attributes_table do
      row :id
      row :property
      row :primary_type
      row :sub_type
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :property,     as: :polymorphic_select, grouped_options: community_select_options, input_html: { class: 'chosen-input' }
      input :primary_type, as: :chosen, collection: PropertyAmenity::PRIMARY_TYPE
      input :sub_type,     as: :chosen, collection: PropertyAmenity::SUB_TYPE
      input :description
    end

    actions
  end
end
