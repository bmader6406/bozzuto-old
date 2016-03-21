ActiveAdmin.register Image do
  menu false

  actions :all, except: :destroy

  permit_params :image, :caption

  filter :image_file_name_or_caption_cont, label: 'Search'

  index do
    column :image do |image|
      image_tag image.url(:thumb)
    end
    column :caption

    actions
  end

  show do |image|
    attributes_table do
      row :id
      row :image do |image|
        image_tag image.image
      end
      row :image_content_type
      row :caption
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :image
      input :caption

      actions
    end
  end

  controller do
    def create
      create! do |format|
        if request.xhr?
          render json: { filelink: resource.image.url, id: resource.id } and return
        else
          format.html { [:admin, resource] }
        end
      end
    end
  end
end
