ActiveAdmin.register ProjectUpdate do
  menu false

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

  show do |update|
    attributes_table do
      row :id
      row :project
      row :image do
        if update.image.present?
          image_tag update.image.url
        end
      end
      row :image_title
      row :image_description
      row :body do
        raw update.body
      end
      row :published do
        status_tag update.published
      end
      row :published_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :project,           as: :chosen
      input :image,             as: :image
      input :image_title
      input :image_description
      input :body,              as: :redactor
      input :published
      input :published_at
    end

    actions
  end
end
