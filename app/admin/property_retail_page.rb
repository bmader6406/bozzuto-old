ActiveAdmin.register PropertyRetailPage do
  menu false

  config.filters = false

  permit_params :property_id,
                :property_type,
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
            row :id
            row :property
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
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :property, as: :polymorphic_select, grouped_options: community_select_options, input_html: { class: 'chosen-input' }
        end

        tab 'Seo' do
          input :meta_title
          input :meta_description
          input :meta_keywords
        end
      end
    end

    actions
  end
end
