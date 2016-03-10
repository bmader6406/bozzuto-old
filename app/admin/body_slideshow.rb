ActiveAdmin.register BodySlideshow do
  menu parent: 'Media', label: 'Page Body Slideshows'

  permit_params :page_id,
                :name,
                slides_attributes: [
                  :id,
                  :image,
                  :link_url,
                  :video_url,
                  :property_id,
                  :_destroy
                ]

  filter :name_cont, label: 'Name'
  filter :page

  index do
    column :name
    column :page

    actions
  end

  show do |slideshow|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for slideshow do
            row :id
            row :name
            row :page
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Slides' do
        collection_panel_for :slides do
          reorderable_table_for slideshow.slides do
            column :image do |slide|
              if slide.image.present?
                image_tag slide.image
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
          input :name
          input :page, as: :chosen
        end

        tab 'Slides' do
          has_many :slides, heading: false, allow_destroy: true do |slide|
            slide.input :image,     as: :image
            slide.input :link_url
            slide.input :video_url
            slide.input :property,  as: :chosen
          end
        end
      end

      actions
    end
  end
end
