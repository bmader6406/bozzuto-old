ActiveAdmin.register OfficeHour do
  menu parent: 'Ronin',
       label:  'Office Hours'

  config.filters = false

  permit_params :property,
                :property_id,
                :day,
                :closed,
                :opens_at,
                :opens_at_period,
                :closes_at,
                :closes_at_period

  index do
    column :property
    column :to_s

    actions
  end

  form do |f|
    inputs do
      input :property
      input :day,               as: :select, collection: OfficeHour::DAY
      input :closed
      input :opens_at
      input :opens_at_period,   as: :select, collection: OfficeHour::MERIDIAN_INDICATORS
      input :closes_at
      input :closes_at_period,  as: :select, collection: OfficeHour::MERIDIAN_INDICATORS
    end

    actions
  end
end
