ActiveAdmin.register PropertyRetailSlide do
  menu false

  reorderable

  track_changes

  config.filters = false

  permit_params :property_retail_page_id,
                :name,
                :image,
                :video_url,
                :link_url

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :property_retail_page
          input :name
          input :image, as: :image
          input :video_url
          input :link_url
        end
      end
    end

    actions
  end
end
