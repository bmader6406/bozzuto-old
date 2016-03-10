ActiveAdmin.register HomePage do
  menu parent: 'Content',
       label:  'Home Page',
       url:    -> { url_for [:admin, :home_page] }

  actions :edit, :update, :show

  permit_params :meta_title,
                :meta_description,
                :meta_keywords,
                :body,
                :mobile_title,
                :mobile_banner_image,
                :mobile_body,
                slides_attributes: [
                  :id,
                  :image,
                  :link_url,
                  :_destroy
                ]

  show do |homepage|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for homepage do
            row :id
            row :meta_title
            row :meta_description
            row :meta_keywords
            row :body do |homepage|
              raw homepage.body
            end
            row :mobile_title
            row :mobile_banner_image do |homepage|
              if homepage.mobile_banner_image.present?
                image_tag homepage.mobile_banner_image
              end
            end
            row :mobile_body do |homepage|
              raw homepage.mobile_body
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Slides' do
        collection_panel_for :slides do
          reorderable_table_for homepage.slides do
            column :image do |slide|
              image_tag slide.image
            end
            column :link_url
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :meta_title
          input :meta_description
          input :meta_keywords
          input :body, as: :redactor
          input :mobile_title
          input :mobile_banner_image, as: :image
          input :mobile_body, as: :redactor
        end

        tab 'Slides' do
          has_many :slides, heading: false, allow_destroy: true do |slide|
            slide.input :image, as: :image
            slide.input :link_url
          end
        end
      end

      actions do
        action :submit
        cancel_link [:admin, :home_page]
      end
    end
  end

  controller do
    defaults singleton: true

    def resource
      @resource ||= HomePage.includes(:slides).first
    end
  end
end
