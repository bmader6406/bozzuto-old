ActiveAdmin.register HospitalBlog do
  menu false

  track_changes

  config.filters = false

  permit_params :title, 
                :url, 
                :listing_image, 
                :hospital_region_id


  index do
    column :title

    actions
  end

  show do |blog|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :id
            row :title
            row :url
            row :listing_image do |blog|
              if blog.listing_image.present?
                image_tag blog.listing_image
              end
            end
            row :hospital_region
            row :created_at
            row :updated_at
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :title
          input :hospital_region,     as: :chosen
          input :url
          input :listing_image,       as: :image, required: true
        end
      end

      actions
    end
  end

  controller do
    def find_resource
      HospitalBlog.find(params[:id])
    end
  end

end
