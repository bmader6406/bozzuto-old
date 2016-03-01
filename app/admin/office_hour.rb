ActiveAdmin.register OfficeHour do
  menu false

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

  show do |office_hour|
    attributes_table do
      row :id
      row :property
      row :day do
        Date::DAYNAMES[office_hour.day]
      end
      row :closed do
        status_tag office_hour.closed
      end
      row :opens_at
      row :opens_at_period
      row :closes_at
      row :closes_at_period
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :property,          as: :chosen
      input :day,               as: :chosen, collection: OfficeHour::DAY
      input :closed
      input :opens_at
      input :opens_at_period,   as: :chosen, collection: OfficeHour::MERIDIAN_INDICATORS
      input :closes_at
      input :closes_at_period,  as: :chosen, collection: OfficeHour::MERIDIAN_INDICATORS
    end

    actions
  end
end
