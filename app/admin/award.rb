ActiveAdmin.register Award do
  config.sort_order = 'published_at'

  menu parent: 'News & Press'

  permit_params :title,
                :published,
                :published_at,
                :featured,
                :image,
                :body,
                :show_as_featured_news,
                :home_page_image

  filter :title_or_body_cont, label: 'Search'
  filter :published_at,       label: 'Published At'

  index do
    column :title
    column :featured
    column :published
    column :published_at

    actions
  end

  form do |f|
    inputs do
      input :title
      input :published
      input :published_at # TODO Datetime picker?
      input :featured
      input :image, as: :image
      input :body # TODO WYSIWYG
      input :show_as_featured_news
      input :home_page_image

      actions
    end
  end
end
