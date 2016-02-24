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
                :home_page_image,
                section_ids: []

  filter :title_or_body_cont, label: 'Search'
  filter :published_at,       label: 'Published At'

  index do
    column :title
    column :featured
    column(:published) { |award| award.published ? status_tag(:yes) : status_tag(:no) }
    column :published_at

    actions
  end

  show do |award|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for award do
            row :title
            row :body
            row :published do |award|
              award.published ? status_tag(:yes) : status_tag(:no)
            end
            row :published_at
            row :image do |award|
              if award.image.present?
                image_tag award.image
              end
            end
            row :featured do |award|
              award.featured ? status_tag(:yes) : status_tag(:no)
            end
            row :show_as_featured_news do |award|
              award.show_as_featured_news ? status_tag(:yes) : status_tag(:no)
            end
            row :home_page_image do |award|
              if award.home_page_image.present?
                image_tag award.home_page_image
              end
            end
          end
        end
      end

      tab 'Sections' do
        collection_panel_for :sections do
          table_for award.sections do
            column :title do |section|
              link_to section.title, [:new_admin, section]
            end
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :title
          input :image, as: :image
          input :body # TODO WYSIWYG
          input :published
          input :published_at # TODO Datetime picker?
          input :featured
          input :show_as_featured_news
          input :home_page_image, as: :image
        end

        tab 'Sections' do
          input :sections
        end
      end

      actions
    end
  end
end
