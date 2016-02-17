ActiveAdmin.register Buzz do
  config.sort_order = 'updated_at'

  menu parent: 'Contact'

  actions :index, :show, :destroy

  filter :first_name_or_last_name_or_email_cont, label: 'Search'

  index do
    column :name
    column :email
    column :city
    column :state
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :street1
      row :street2
      row :city
      row :state
      row :zip_code
      row :phone
      row :formatted_buzzes
      row :formatted_affiliations
      row :created_at
      row :updated_at
    end
  end
end
