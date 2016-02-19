ActiveAdmin.register Metro do
  menu parent: 'Neighborhoods'

  permit_params :name,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :detail_description,
                :position

  filter :name_cont, label: 'Name'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Metro.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
    column :name

    actions
  end

  form do |f|
    inputs do
      input :name
      input :latitude
      input :longitude
      input :banner_image
      input :listing_image
      input :detail_description
    end

    actions
  end
end
