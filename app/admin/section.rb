ActiveAdmin.register Section do
  menu parent: 'Content'

  actions :index, :show, :edit, :update

  config.sort_order = 'title_asc'

  permit_params :left_montage_image,
                :middle_montage_image,
                :right_montage_image

  filter :title_cont, label: 'Title'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Section.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
    column :title

    actions
  end

  show do
    attributes_table do
      rows :id
      rows :title
      rows :service, :about
      rows :left_montage_image, :middle_montage_image, :right_montage_image
      rows :created_at, :updated_at
    end
  end

  form do |f|
    inputs do
      input :title, :input_html => { :disabled => true } 
      input :left_montage_image, as: :image
      input :middle_montage_image, as: :image
      input :right_montage_image, as: :image
    end

    actions
  end
end
