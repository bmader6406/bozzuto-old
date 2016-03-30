ActiveAdmin.register Home do
  menu parent: 'Properties', label: 'Home Floor Plans'

  track_changes

  reorderable

  permit_params :name,
                :bedrooms,
                :bathrooms,
                :square_feet,
                :featured,
                :home_community_id,
                floor_plans_attributes: [
                  :id,
                  :home_id,
                  :name,
                  :image,
                  :_destroy
                ]

  filter :name_cont, label: 'Name'
  filter :bedrooms
  filter :bathrooms
  filter :home_community
  filter :featured

  index do
    column :name
    column :bedrooms
    column :bathrooms
    column :featured

    actions
  end

  show do |home|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for home do
            row :id
            row :home_community
            row :name
            row :bedrooms
            row :bathrooms
            row :square_feet
            row :featured do |home|
              status_tag home.featured
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Floor Plans' do
        collection_panel_for :floor_plans do
          reorderable_table_for home.floor_plans do
            column :name
            column :image do |plan|
              if plan.image.present?
                image_tag plan.image
              end
            end
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :home_community, as: :chosen
          input :name
          input :bedrooms
          input :bathrooms
          input :square_feet
          input :featured
        end

        tab 'Floor Plans' do
          has_many :floor_plans, allow_destroy: true, heading: false, new_record: 'Add Floor Plan' do |plan|
            plan.input :name
            plan.input :image, as: :image
          end
        end
      end

      actions
    end
  end
end
