ActiveAdmin.register PropertyNeighborhoodPage do
  menu false

  config.filters = false

  permit_params :property,
                :property_id,
                :content,
                :meta_title,
                :meta_description,
                :meta_keywords

  index do
    column :property
    column :meta_title

    actions
  end

  form do |f|
    inputs do
      input :content, as: :redactor
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :property
    end

    actions
  end
end
