ActiveAdmin.register PropertySlideshow do
  menu parent: 'Ronin',
       label:  'Property Slideshows'

  permit_params :property,
                :property_id,
                :name

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :property

    actions
  end

  form do |f|
    inputs do
      input :name
      input :property
    end

    actions
  end
end
