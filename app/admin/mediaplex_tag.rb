ActiveAdmin.register MediaplexTag do
  menu parent: 'Ronin',
       label:  'Mediaplex Tags'

  config.filters = false

  permit_params :page_name,
                :roi_name

  index do
    column :page_name
    column :roi_name

    actions
  end

  form do |f|
    inputs do
      input :page_name
      input :roi_name
    end

    actions
  end
end
