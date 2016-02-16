ActiveAdmin.register State do
  menu parent: 'Geography'

  config.sort_order = 'name_asc'

  permit_params :name,
                :code

  filter :name_cont, label: "Name"

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    State.class_eval do
      def to_param
        id.to_s
      end
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
