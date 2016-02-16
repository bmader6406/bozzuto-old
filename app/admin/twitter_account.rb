ActiveAdmin.register TwitterAccount do
  menu parent: 'Ronin'

  permit_params :username

  filter :username_cont, label: 'Username'

  index do
    column :username

    actions
  end

  form do |f|
    inputs do
      input :username
    end

    actions
  end
end
