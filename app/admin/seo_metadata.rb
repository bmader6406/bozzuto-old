ActiveAdmin.register SeoMetadata do
  menu parent: 'Ronin'

  permit_params :resource,
                :resource_id,
                :resource_type,
                :meta_title,
                :meta_keywords,
                :meta_description

  filter :meta_title_cont,       label: 'Meta Title'
  filter :meta_keywords_cont,    label: 'Meta Keywords'
  filter :meta_description_cont, label: 'Meta Description'

  index do
    column :meta_title
    column :meta_keywords
    column :meta_description

    actions
  end

  form do |f|
    inputs do
      input :meta_title
      input :meta_keywords
      input :meta_description
    end

    actions
  end
end
