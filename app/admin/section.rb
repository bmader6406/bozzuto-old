ActiveAdmin.register Section do
  menu parent: 'Content'

  track_changes

  actions :index, :show, :edit, :update

  config.sort_order = 'title_asc'

  permit_params :left_montage_image,
                :middle_montage_image,
                :right_montage_image

  filter :title_cont, label: 'Title'

  index do
    column :title

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :id
            row :title
            row :slug
            row :service do
              status_tag resource.service
            end
            row :about do
              status_tag resource.about
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Montage' do
        panel nil do
          attributes_table_for resource do
            row :left_montage_image do
              if resource.left_montage_image.present?
                image_tag resource.left_montage_image.url
              end
            end
            row :middle_montage_image do
              if resource.middle_montage_image.present?
                image_tag resource.middle_montage_image.url
              end
            end
            row :right_montage_image do
              if resource.right_montage_image.present?
                image_tag resource.right_montage_image.url
              end
            end
          end
        end
      end

      tab 'Pages' do
        collection_panel_for :pages do
          table_for resource.pages do
            column :title do |d|
              link_to d.title, [:admin, d]
            end
            column :published
          end
        end
      end

      tab 'Projects' do
        collection_panel_for :projects do
          reorderable_table_for resource.projects.includes(:city).position_asc do
            column :position
            column :title do |p|
              link_to p.title, [:admin, p]
            end
            column :published
            column :street_address
            column :city
          end
        end
      end

      tab 'Testimonials' do
        collection_panel_for :testimonials do
          table_for resource.testimonials do
            column :name
            column :title
            column :quote do |t|
              t.excerpt
            end
          end
        end
      end

      tab 'Awards' do
        collection_panel_for :awards do
          table_for resource.awards do
            column :title do |award|
              link_to award, [:admin, award], target: :blank
            end
            column :published
            column :published_at
          end
        end
      end

      tab 'News Posts' do
        collection_panel_for :news_posts do
          table_for resource.news_posts do
            column :title do |news_post|
              link_to news_post, [:admin, news_post], target: :blank
            end
            column :published
            column :published_at
          end
        end
      end

      tab 'Press Releases' do
        collection_panel_for :press_releases do
          table_for resource.press_releases do
            column :title do |press_release|
              link_to press_release, [:admin, press_release], target: :blank
            end
            column :published
            column :published_at
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :title, :input_html => { :disabled => true }
        end

        tab 'Montage' do
          input :left_montage_image,   as: :image
          input :middle_montage_image, as: :image
          input :right_montage_image,  as: :image
        end

        tab 'Pages' do
          panel nil do
            association_table_for :pages do
              column :title
              column :published
            end
          end
        end

        tab 'Projects' do
          panel nil do
            association_table_for :projects, scope: resource.projects.includes(:city).position_asc do
              column :position
              column :title
              column :published
              column :street_address
              column :city
            end
          end
        end

        tab 'Testimonials' do
          panel nil do
            association_table_for :testimonials do
              column :name
              column :title
              column :quote do |t|
                t.excerpt
              end
            end
          end
        end

        tab 'Awards' do
          panel nil do
            association_table_for :awards do
              column :title
              column :published
              column :published_at
            end
          end
        end

        tab 'News Posts' do
          panel nil do
            association_table_for :news_posts do
              column :title
              column :published
              column :published_at
            end
          end
        end

        tab 'Press Releases' do
          panel nil do
            association_table_for :press_releases do
              column :title
              column :published
              column :published_at
            end
          end
        end
      end
    end

    actions
  end

  controller do
    def find_resource
      Section.friendly.find(params[:id])
    end
  end
end
