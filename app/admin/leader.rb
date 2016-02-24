ActiveAdmin.register Leader do
  menu parent: 'Leaders'

  config.sort_order = "name_asc"

  config.filters = false

  permit_params :name,
                :title,
                :company,
                :bio,
                :image

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Leader.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
    column :name
    column :title
    column :company

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :title
      row :company
      row :image do
        if resource.image.present?
          image_tag resource.image.url
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :name
      input :title
      input :company
      input :bio
      input :image,   as: :image
    end
    
    actions
  end
end
