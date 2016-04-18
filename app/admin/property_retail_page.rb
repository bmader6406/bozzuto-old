ActiveAdmin.register PropertyRetailPage do
  menu false

  track_changes

  config.filters = false

  permit_params :property_id,
                :property_type,
                :content,
                :meta_title,
                :meta_description,
                :meta_keywords

  index do
    column :property
    column :meta_title

    actions
  end

  show do |page|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for page do
            row :property
            row :content
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Seo' do
        panel nil do
          attributes_table_for page do
            row :meta_title
            row :meta_description
            row :meta_keywords
          end
        end
      end

      tab 'Slides' do
        collection_panel_for :slides do
          reorderable_table_for page.slides do
            column :name
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
          input :property, as: :polymorphic_select, grouped_options: community_select_options, input_html: { class: 'chosen-input' }
          input :content,  as: :redactor
        end

        tab 'Seo' do
          input :meta_title
          input :meta_description
          input :meta_keywords
        end

        tab 'Slides' do
          association_table_for :slides, reorderable: true do
            column :name
            column :image do |slide|
              if slide.image.present?
                image_tag slide.image.url(:thumb)
              end
            end
          end
        end
      end
    end

    actions
  end
end
