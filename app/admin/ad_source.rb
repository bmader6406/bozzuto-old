ActiveAdmin.register AdSource do
  menu parent: 'System'

  permit_params :domain_name, :value

  filter :domain_name_cont, label: 'Domain Name'
  filter :value_cont,       label: 'Value'

  index do
    column :domain_name
    column :value

    actions
  end

  form do |f|
    inputs do
      input :domain_name
      input :value
    end

    actions
  end
end
