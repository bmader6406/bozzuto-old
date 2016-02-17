ActiveAdmin.register NewsPost do
  menu parent: 'News & Press',
       label:  'News'

  permit_params :title

  filter :title_cont, label: 'Title'

  index do
    column :title
    column :featured
    column :published
    column :publsihed_at

    actions
  end

  form do |f|
    inputs do
      input :title
      input :published
      input :published_at
      input :featured
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :image
      input :body
      input :show_as_featured_news
      input :home_page_image
    end

    actions
  end
end
