ActiveAdmin.register PropertyFeaturesPage do
  menu false

  config.filters = false

  permit_params :property,
                :property_id,
                :property_type,
                :text_1,
                :title_1,
                :title_2,
                :text_2,
                :title_3,
                :text_3,
                :meta_title,
                :meta_description,
                :meta_keywords

  index do
    column :property
    column :meta_title
    column :title_1

    actions
  end

  show do |page|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for page do
            row :id
            row :property
            row :title_1
            row :text_1 do
              raw page.text_1
            end
            row :title_2
            row :text_2 do
              raw page.text_2
            end
            row :title_3
            row :text_3 do
              raw page.text_3
            end
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
          input :title_1
          input :text_1,   as: :redactor
          input :title_2
          input :text_2,   as: :redactor
          input :title_3
          input :text_3,   as: :redactor
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
