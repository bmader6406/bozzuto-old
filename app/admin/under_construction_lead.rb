ActiveAdmin.register UnderConstructionLead do
  menu parent: 'Contact', label: 'Under Construction Leads'

  actions :index, :show, :destroy

  permit_params :first_name,
                :last_name,
                :address,
                :address_2,
                :city,
                :state,
                :zip_code,
                :phone_number,
                :email,
                :comments

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
      rows :id
      rows :apartment_community
      rows :first_name, :last_name
      rows :email, :phone_number
      rows :address, :address_2, :city, :state, :zip_code
      rows :comments
      rows :created_at
    end
  end
end
