ActiveAdmin.register Neighborhood do
  menu parent: 'Neighborhoods',
       label:  'Neighborhoods'

  permit_params :name,
                :area,
                :area_id,
                :state,
                :state_id,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :description,
                :detail_description,
                :featured_apartment_coummunity,
                :featured_apartment_coummunity_id

  filter :name_cont, label: 'Name'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Neighborhood.class_eval do
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
      input :area
      input :state
      input :latitude
      input :longitude
      input :banner_image
      input :listing_image
      input :description
      input :detail_description
      input :featured_apartment_community
    end

    actions
  end
end
