ActiveAdmin.register NotificationRecipient do
  menu parent: 'System'

  actions :all, except: :show

  permit_params :admin_user_id,
                :email

  filter :admin_user, label: 'Admin User'
  filter :email_cont, label: 'Email'

  index do
    column 'Email', &:contact_email
    column :admin_user

    actions
  end

  show title: :contact_email do
    attributes_table do
      row :admin_user
      row :email
    end
  end

  form do |f|
    panel 'Usage' do
      span 'Either select an existing admin user or enter an email address.'
      span 'Notification recipients will receive email addresses for all notifications.'
    end

    inputs do
      input :admin_user, label: 'Admin User'
      input :email
    end

    actions
  end
end
