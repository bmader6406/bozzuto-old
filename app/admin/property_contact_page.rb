ActiveAdmin.register PropertyContactPage do
  menu false

  config.filters = false

  permit_params :property,
                :property_id,
                :property_type,
                :contact_form_note,
                :thank_you_text,
                :content,
                :schedule_appointment_url,
                :local_phone_number,
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
            row :schedule_appointment_url
            row :local_phone_number
            row :contact_form_note do
              raw page.contact_form_note
            end
            row :thank_you_text do
              raw page.thank_you_text
            end
            row :content do
              raw page.content
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
          input :property,                 as: :polymorphic_select, grouped_options: community_select_options, input_html: { class: 'chosen-input' }
          input :schedule_appointment_url
          input :local_phone_number
          input :contact_form_note,        as: :redactor
          input :thank_you_text,           as: :redactor
          input :content,                  as: :redactor
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
