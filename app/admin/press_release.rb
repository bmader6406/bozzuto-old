ActiveAdmin.register PressRelease do
  menu parent: 'News & Press',
       label:  'Press Releases'

  permit_params :title,
                :published,
                :published_at,
                :featured,
                :body,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :show_as_featured_news,
                :home_page_image

  filter :title_cont, label: 'Title'
  filter :published

  index do
    column :title
    column :published
    column :published_at

    actions
  end

  form do |f|
    inputs do
      input :title
      input :published
      input :published_at
      input :featured
      input :body
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :show_as_featured_news
      input :home_page_image
    end

    actions
  end
end
