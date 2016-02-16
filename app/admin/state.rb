ActiveAdmin.register State do
  menu parent: 'Geography'

  config.sort_order = 'name_asc'

  permit_params :name,
                :code

  filter :name_cont, label: "Name"

  controller do
    def find_resource
      scoped_collection.find_by(code: params[:id])
    end
  end

  index do
    column :name
    column :code

    actions
  end

  form do |f|
    inputs do
      input :name
      input :code
    end

    actions
  end
end
