ActiveAdmin.register Page do
  menu parent: 'Content'

  config.sort_order = "section_id_desc"

  reorderable

  permit_params :title,
                :section,
                :section_id,
                :parent,
                :parent_id,
                :published,
                :show_sidebar,
                :show_in_sidebar_nav,
                :snippet,
                :snippet_id,
                :body,
                :mobile_body,
                :mobile_body_extra,
                :left_montage_image,
                :middle_montage_image,
                :right_montage_image,
                :meta_title,
                :meta_description,
                :meta_keywords

  filter :title_cont, label: 'Title'
  filter :section,    collection: Section.ordered_by_title

  index do
    column :title
    column :published
    column :section

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
            row :section
            row :parent
            row :published do |p|
              status_tag p.published
            end
            row :show_sidebar do |p|
              status_tag p.show_sidebar
            end
            row :show_in_sidebar_nav do |p|
              status_tag p.show_in_sidebar_nav
            end
            row :snippet
          end
        end
      end

      tab 'Content' do
        panel nil do
          attributes_table_for resource do
            row :body do |p|
              raw p.body
            end
            row :mobile_body do |p|
              raw p.mobile_body
            end
            row :mobile_body_extra do |p|
              raw p.mobile_body_extra
            end
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

      tab 'Seo' do
        panel nil do
          attributes_table_for resource do
            row :meta_title
            row :meta_description
            row :meta_keywords
          end
        end
      end

      tab 'Slideshows & Carousel' do
        panel nil do
          table_for slideshows do
            column nil do |slideshow|
              slideshow.label + ':'
            end

            column nil do |slideshow|
              if slideshow.present?
                link_to slideshow.name, slideshow.url_params(:show)
              else
                link_to "Add New #{slideshow.label}", slideshow.url_params(:new), class: 'button', target: :blank
              end
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
          input :section,             as: :chosen
          input :parent,              as: :chosen
          input :published
          input :show_sidebar
          input :show_in_sidebar_nav
          input :snippet,             as: :chosen
        end

        tab 'Content' do
          input :body,              as: :redactor
          input :mobile_body,       as: :redactor
          input :mobile_body_extra, as: :redactor
        end

        tab 'Montage' do
          input :left_montage_image,   as: :image
          input :middle_montage_image, as: :image
          input :right_montage_image,  as: :image
        end

        tab 'Seo' do
          input :meta_title
          input :meta_description
          input :meta_keywords
        end

        tab 'Slideshows & Carousel' do
          slideshows.each do |slideshow|
            panel slideshow.label do
              association_table_for slideshow.type do
                column :name
              end
            end
          end
        end
      end
    end

    actions
  end

  controller do
    def find_resource
      Page.includes(:masthead_slideshow, :body_slideshow, :carousel).friendly.find(params[:id])
    end

    def scoped_collection
      super.includes(:section)
    end

    def slideshows
      @slideshows ||= [
        Bozzuto::SlideshowWrapper.new(:masthead_slideshow, resource),
        Bozzuto::SlideshowWrapper.new(:body_slideshow, resource),
        Bozzuto::SlideshowWrapper.new(:carousel, resource)
      ]
    end
    helper_method :slideshows
  end
end
