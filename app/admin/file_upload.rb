ActiveAdmin.register FileUpload do
  menu parent: 'Media'

  actions :all, except: :destroy

  permit_params :file

  filter :file_file_name_cont, label: 'Search'

  index do
    column :file

    actions
  end

  show do |file_upload|
    attributes_table do
      row :file
      row :file_content_type
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :file

      actions
    end
  end

  controller do
    def create
      create! do |format|
        if request.xhr?
          render json: { filelink: resource.file.url, id: resource.id } and return
        else
          format.html { [:admin, resource] }
        end
      end
    end
  end
end
