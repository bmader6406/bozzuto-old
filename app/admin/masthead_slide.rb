ActiveAdmin.register MastheadSlide do
  config.filters = false

  menu false

  reorderable

  permit_params :body,
                :slide_type,
                :image,
                :image_link,
                :sidebar_text,
                :masthead_slideshow_id,
                :mini_slideshow_id,
                :quote,
                :quote_attribution,
                :quote_job_title,
                :quote_company


  index do
    column :image do |slide|
      if slide.image.present?
        image_tag slide.image
      end
    end
    column :image_link

    actions
  end

  show do |slide|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for slide do
            row :id
            row :masthead_slideshow
            row :body
            row :slide_type do |slide|
              slide.type_label
            end
            row :image do |slide|
              if slide.image.present?
                image_tag slide.image
              end
            end
            row :image_link
            row :sidebar_text
            row :mini_slideshow
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Quote Fields' do
        panel nil do
          attributes_table_for slide do
            row :quote
            row :quote_attribution
            row :quote_job_title
            row :quote_company
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :masthead_slideshow,  as: :chosen
          input :mini_slideshow,      as: :chosen
          input :body,                as: :redactor
          input :slide_type,          as: :select,  collection: MastheadSlide::SLIDE_TYPE
          input :image,               as: :image
          input :image_link
          input :sidebar_text,        as: :redactor
        end

        tab 'Quote Fields' do
          input :quote,             as: :redactor
          input :quote_attribution
          input :quote_job_title
          input :quote_company
        end
      end
    end

    actions
  end
end
