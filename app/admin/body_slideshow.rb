ActiveAdmin.register BodySlideshow do
  menu parent: 'Ronin'

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
            row :name
            row :page
          end
        end
      end

      tab 'Slides' do
        panel nil do
          if slideshow.slides.any?
            reorderable_table_for slideshow.slides do
              column :image do |slide|
                if slide.image.present?
                  image_tag slide.image
                end
              end
            end
          else
            div class: 'blank_slate_container' do
              span class: 'blank_slate' do
                span 'No Slides'
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
          input :page
        end

        tab 'Slides' do
          has_many :slides, heading: false, allow_destroy: true do |slide|
            slide.input :image
            slide.input :link_url
            slide.input :video_url
            slide.input :property
          end
        end
      end

      actions
    end
  end
end
