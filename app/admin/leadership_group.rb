ActiveAdmin.register LeadershipGroup do
  config.sort_order = "position_asc"
  config.filters    = false

  menu parent: 'Leaders',
       label:  'Leadership Groups'

  track_changes

  reorderable

  permit_params :name

  index as: :reorderable_table do
    column :name

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :id
            row :name
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Leaders' do
        collection_panel_for :leaders do
          table_for resource.leaders do
            column :name
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :name
        end

        tab 'Leaders' do
          panel nil do
            association_table_for :leaders do
              column :name
            end
          end
        end
      end
    end

    actions
  end
end
