ActiveAdmin.register PressRelease do
  menu parent: 'News & Press',
       label:  'Press Releases'

  track_changes

  permit_params :title,
                :published,
                :published_at,
                :featured,
                :show_as_featured_news,
                :home_page_image,
                :body,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :tag_list

  filter :title_cont, label: 'Title'
  filter :published

  before_filter do
    PressRelease.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
    column :title
    column :published
    column :published_at do |release|
      if release.published_at.present?
        release.published_at.to_s(:extensive)
      end
    end

    actions
  end

  show do |press_release|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for press_release do
            row :id
            row :title
            row :slug
            row :published do
              status_tag press_release.published
            end
            row :published_at do
              if press_release.published_at.present?
                press_release.published_at.to_s(:extensive)
              end
            end
            row :featured do
              status_tag press_release.featured
            end
            row :body do
              raw press_release.body
            end
            row :show_as_featured_news do
              status_tag press_release.show_as_featured_news
            end
            row :home_page_image do
              if press_release.home_page_image.present?
                image_tag press_release.home_page_image.url
              end
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Seo' do
        panel nil do
          attributes_table_for press_release do
            row :meta_title
            row :meta_description
            row :meta_keywords
          end
        end
      end

      tab 'Search' do
        panel nil do
          attributes_table_for press_release do
            row "Tags" do |press_release|
              press_release.tag_list.join(', ')
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
          input :published_at,          as: :datetime_picker
          input :featured
          input :show_as_featured_news
          input :home_page_image,       as: :image
          input :body,                  as: :redactor
        end

        tab 'Seo' do
          input :meta_title
          input :meta_description
          input :meta_keywords
        end

        tab 'Search' do
          input :tag_list, as: :string, input_html: { value: f.object.tag_list.join(', ') }
        end
      end
    end

    actions
  end
end
