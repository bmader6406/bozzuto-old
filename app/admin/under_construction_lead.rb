ActiveAdmin.register UnderConstructionLead do
  menu parent: 'Leads', label: 'Under Construction Leads'

  actions :index, :show, :destroy

  filter :first_name_cont, label: "First Name"
  filter :last_name_cont,  label: "Last Name"
  filter :email_cont,      label: "Email"

  index do
    column :apartment_community
    column :first_name
    column :last_name
    column :email

    actions
  end

  show do
    attributes_table do
      row :id
      row :apartment_community
      row :first_name
      row :last_name
      row :email
      row :phone_number
      row :address
      row :address_2
      row :city
      row :state
      row :zip_code
      row :comments
      row :created_at
    end
  end

  csv do
    column :property do |lead|
      lead.apartment_community.to_s
    end

    column :name do |lead|
      [lead.first_name, lead.last_name].join(' ')
    end

    column :email
    column :phone_number
    column :address
    column :address_2
    column :city
    column :state
    column :zip_code
    column :comments
  end
end
