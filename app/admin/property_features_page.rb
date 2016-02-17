ActiveAdmin.register PropertyFeaturesPage do
  menu parent: 'Ronin',
       label:  'Property Features Pages'

  config.filters = false

  permit_params :property,
                :property_id,
                :text_1,
                :title_1,
                :title_2,
                :text_2,
                :title_3,
                :text_3,
                :meta_title,
                :meta_description,
                :meta_keywords

  index do
    column :property
    column :meta_title
    column :title_1

    actions
  end

  form do |f|
    inputs do
      input :title_1
      input :text_1
      input :title_2
      input :text_2
      input :title_3
      input :text_3
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :property
    end

    actions
  end
end
