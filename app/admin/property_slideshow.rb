ActiveAdmin.register PropertySlideshow do
  menu parent: 'Media',
       label:  'Property Slideshows'

  track_changes

  permit_params :property,
                :property_id,
                :property_type,
                :name

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :property

    actions
  end

  show do |slideshow|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for slideshow do
            row :id
            row :name
            row :property
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
                image_tag slide.image.url(:thumb)
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
          input :property, as: :polymorphic_select, grouped_options: property_select_options, input_html: { class: 'chosen-input' }
        end

        tab 'Slides' do
          association_table_for :slides, reorderable: true do
            column :image do |slide|
              if slide.image.present?
                image_tag slide.image.url(:thumb)
              end
            end
          end
        end
      end

      actions
    end
  end
end
