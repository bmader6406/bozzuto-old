ActiveAdmin.register MiniSlideshow do
  menu parent: 'Media',
       label:  'Mini Slideshows'

  permit_params :title,
                :subtitle,
                :link_url,
                slides_attributes: [
                  :id,
                  :mini_slideshow_id,
                  :image,
                  :_destroy
                ]

  filter :title_cont, label: 'Title'

  index do
    column :title

    actions
  end

  show do |slideshow|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for slideshow do
            row :title
            row :subtitle
            row :link_url
          end
        end
      end

      tab 'Slides' do
        panel nil do
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
          input :title
          input :subtitle
          input :link_url
        end

        tab 'Slides' do
          has_many :slides, allow_destroy: true, heading: false, new_record: 'Add Slide' do |slide|
            slide.input :image, as: :image
          end
        end
      end
    end

    actions
  end
end
