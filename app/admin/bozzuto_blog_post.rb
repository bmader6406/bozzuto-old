ActiveAdmin.register BozzutoBlogPost do
  config.sort_order = 'published_at'

  menu parent: 'Content', label: 'Bozzuto Blog Posts'

  permit_params :header_title,
                :header_url,
                :title,
                :url,
                :published_at,
                :image

  filter :title_cont, label: 'Title'

  index do
    column :title
    column :published_at do |post|
      if post.published_at.present?
        post.published_at.to_s(:extensive)
      end
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :header_title
      row :header_url
      row :title
      row :url
      row :image do |post|
        if post.image.present?
          image_tag post.image
        end
      end
      row :published_at do |post|
        if post.published_at.present?
          post.published_at.to_s(:extensive)
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :header_title
      input :header_url
      input :title
      input :url
      input :published_at,  as: :datetime_picker
      input :image,         as: :image

      actions
    end
  end
end
