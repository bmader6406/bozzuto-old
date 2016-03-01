ActiveAdmin.register UnderConstructionLead do
  menu parent: 'Contact', label: 'Under Construction Leads'

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
end
