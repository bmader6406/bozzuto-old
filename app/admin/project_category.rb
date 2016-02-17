ActiveAdmin.register ProjectCategory do
  menu parent: 'Properties'

  permit_params :title

  filter :title_cont, label: 'Title'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    ProjectCategory.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
    column :title

    actions
  end

  form do |f|
    inputs do
      input :title
    end

    actions
  end
end
