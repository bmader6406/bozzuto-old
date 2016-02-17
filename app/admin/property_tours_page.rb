ActiveAdmin.register PropertyToursPage do
  menu parent: 'Ronin',
       label:  'Property Tours Pages'

  permit_params :property,
                :property_id,
                :title,
                :content,
                :meta_title,
                :meta_description,
                :meta_keywords

  filter :title_cont, label: 'Title'

  index do
    column :property
    column :title

    actions
  end

  form do |f|
    inputs do
      input :title
      input :content
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :property
    end

    actions
  end
end
