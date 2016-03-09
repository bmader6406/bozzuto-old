ActiveAdmin.register AdminUser do
  config.sort_order = 'name_asc'

  menu parent: 'System', label: 'Admin Users'

  permit_params :name,
                :email,
                :password,
                :password_confirmation

  filter :name_or_email_cont, label: 'Search'

  index do
    column :name
    column :email
    column :current_sign_in_at

    actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs 'Details' do
      input :name
      input :email
      input :password
      input :password_confirmation
    end

    actions
  end

  controller do
    before_action :strip_empty_password_parameters, only: [:create, :update]

    private

    def strip_empty_password_parameters
      if params[:admin_user][:password].to_s.empty?
        params[:admin_user].delete(:password)
        params[:admin_user].delete(:password_confirmation)
      end
    end
  end
end
