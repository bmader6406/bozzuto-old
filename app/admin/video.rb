ActiveAdmin.register Video do
  menu parent: 'Media'

  track_changes

  reorderable

  config.filters = false

  permit_params :property,
                :property_id,
                :property_type,
                :image,
                :url,
                :position

  index do
    column :name do |video|
      video.to_s
    end
    column :property

    actions
  end

  show do
    attributes_table do
      row :name do |video|
        video.to_s
      end
      row :property
      row :url
      row :image do |video|
        if video.image.present?
          image_tag video.image
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :property, as: :polymorphic_select, grouped_options: property_select_options, input_html: { class: 'chosen-input' }
      input :image,    as: :image
      input :url
    end

    actions
  end
end
