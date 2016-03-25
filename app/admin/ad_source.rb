ActiveAdmin.register AdSource do
  menu parent: 'System',
       label:  'Ad Sources'

  track_changes

  config.sort_order = 'domain_name_asc'

  permit_params :domain_name,
                :value

  filter :domain_name_cont, label: 'Domain Name'
  filter :value_cont,       label: 'Value'

  index do
    column :domain_name
    column :value

    actions
  end

  show do
    attributes_table do
      row :id
      row :domain_name
      row :value
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :domain_name
      input :value
    end

    actions
  end
end
