ActiveAdmin.register Video do
  menu parent: 'Ronin'

  reorderable

  config.filters = false

  permit_params :property,
                :property_id,
                :image,
                :url,
                :position

  index do
    column :property

    actions
  end

  show do
    attributes_table do
      rows :id
      rows :property, :image, :url
      rows :created_at, :updated_at
    end
  end

  form do |f|
    inputs do
      input :property
      input :image
      input :url
    end

    actions
  end
end
