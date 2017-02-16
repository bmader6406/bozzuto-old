ActiveAdmin.register Leader do
  config.sort_order = "name_asc"
  config.filters    = false

  menu parent: 'Leaders'

  track_changes

  permit_params :name,
                :title,
                :company,
                :bio,
                :image,
                :tag_list

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
      row "Tags" do |leader|
        leader.tag_list.join(', ')
      end
    end
  end

  form do |f|
    inputs do
      input :name
      input :title
      input :company
      input :bio
      input :image,   as: :image
      input :tag_list, as: :string, input_html: { value: f.object.tag_list.join(', ') }
    end
    
    actions
  end
end
