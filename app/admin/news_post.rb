ActiveAdmin.register NewsPost do
  menu parent: 'News & Press',
       label:  'News'

  permit_params :title,
                :published,
                :published_at,
                :featured,
                :show_as_featured_news,
                :image,
                :home_page_image,
                :body,
                :meta_title,
                :meta_description,
                :meta_keywords

  filter :title_cont, label: 'Title'

  index do
    column :title
    column :featured
    column :published
    column :published_at

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :id
            row :title
            row :published do
              status_tag resource.published
            end
            row :published_at
            row :featured do
              status_tag resource.featured
            end
            row :show_as_featured_news do
              status_tag resource.show_as_featured_news
            end
            row :image do
              if resource.image.present?
                image_tag resource.image.url
              end
            end
            row :home_page_image do
              if resource.home_page_image.present?
                image_tag resource.home_page_image.url
              end
            end
            row :body do
              raw resource.body
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Seo Metadata' do
        panel nil do
          attributes_table_for resource do
            row :meta_title
            row :meta_description
            row :meta_keywords
          end
        end
      end

      tab 'Sections' do
        collection_panel_for :sections do
          table_for resource.sections do
            column :title do |s|
              link_to s.title, [:new_admin, s]
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
          input :published
          input :published_at
          input :featured
          input :show_as_featured_news
          input :image,                 as: :image
          input :home_page_image,       as: :image
          input :body,                  as: :redactor
        end

        tab 'Seo Metadata' do
          input :meta_title
          input :meta_description
          input :meta_keywords
        end

        tab 'Sections' do
          panel nil do
            table_for resource.sections do
              column :title
            end
          end
        end
      end
    end

    actions
  end
end
