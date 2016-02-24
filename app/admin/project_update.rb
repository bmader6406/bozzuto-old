ActiveAdmin.register ProjectUpdate do
  menu parent: 'Ronin',
       label:  'Project Updates'

  config.filters = false

  reorderable

  permit_params :project,
                :project_id,
                :image,
                :image_title,
                :image_description,
                :body,
                :published,
                :published_at

  index do
    column :project
    column :published

    actions
  end

  form do |f|
    inputs do
      input :image,             as: :image
      input :image_title
      input :image_description
      input :body,              as: :redactor
      input :published
      input :published_at
      input :project
    end

    actions
  end
end
