ActiveAdmin.register MastheadSlideshow do
  menu parent: 'Media',
       label:  'Masthead Slideshows'

  track_changes

  permit_params :name,
                :page,
                :page_id

  filter :name_cont, label: 'Name'

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
            column 'Slide Type' do |slide|
              slide.type_label
            end
            column :image do |slide|
              if slide.image.present?
                image_tag slide.image
              end
            end
            column :image_link
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
          association_table_for :slides, reorderable: true do
            column 'Slide Type' do |slide|
              slide.type_label
            end
            column :image do |slide|
              if slide.image.present?
                image_tag slide.image
              end
            end
            column :image_link
          end
        end
      end

      actions
    end
  end
end
