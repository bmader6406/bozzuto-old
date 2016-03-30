ActiveAdmin.register Award do
  config.sort_order = 'published_at'

  track_changes

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
    column :published
    column :published_at do |award|
      if award.published_at.present?
        award.published_at.to_s(:extensive)
      end
    end

    actions
  end

  show do |award|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for award do
            row :id
            row :title
            row :body
            row :published do |award|
              status_tag award.published
            end
            row :published_at do |award|
              if award.published_at.present?
                award.published_at.to_s(:extensive)
              end
            end
            row :image do |award|
              if award.image.present?
                image_tag award.image
              end
            end
            row :featured do |award|
              status_tag award.featured
            end
            row :show_as_featured_news do |award|
              status_tag award.show_as_featured_news
            end
            row :home_page_image do |award|
              if award.home_page_image.present?
                image_tag award.home_page_image
              end
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Sections' do
        collection_panel_for :sections do
          table_for award.sections do
            column :title do |section|
              link_to section.title, [:admin, section]
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
          input :image,                 as: :image
          input :body,                  as: :redactor
          input :featured
          input :show_as_featured_news
          input :home_page_image,       as: :image
          input :published
          input :published_at,          as: :datetime_picker
        end

        tab 'Sections' do
          input :sections, as: :chosen
        end
      end

      actions
    end
  end
end
