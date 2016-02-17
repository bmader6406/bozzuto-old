ActiveAdmin.register PropertyContactPage do
  menu parent: 'Ronin',
       label:  'Property Contact Pages'

  config.filters = false

  permit_params :property,
                :property_id,
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

  form do |f|
    inputs do
      input :content
      input :schedule_appointment_url
      input :local_phone_number
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :property
    end

    actions
  end
end
