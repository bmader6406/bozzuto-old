ActiveAdmin.register HomePage do
  menu parent: 'Content',
       label:  'Home Page',
       url:    -> { url_for [:admin, :home_page] }

  actions :edit, :update, :show

  permit_params :meta_title,
                :meta_description,
                :meta_keywords,
                :headline,
                :apartment_subheadline,
                :home_subheadline,
                :body,
                :body_sub_image,
                :mobile_title,
                :mobile_banner_image,
                :mobile_body,
                slides_attributes: [
                  :id,
                  :image,
                  :call_to_action,
                  :link_url,
                  :description,
                  :_destroy
                ],
                home_section_slides_attributes: [
                  :id,
                  :image,
                  :text,
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
            row :headline
            row :apartment_subheadline
            row :home_subheadline
            row :body do |homepage|
              raw homepage.body
            end
            row :body_sub_image do |homepage|
              if homepage.body_sub_image.present?
                image_tag homepage.body_sub_image
              end
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
            column :call_to_action
            column :link_url, label: 'Link URL'
            column :description
          end
        end
      end

      tab 'Home Community Section' do
        collection_panel_for :home_section_slides do
          reorderable_table_for homepage.home_section_slides do
            column :image do |slide|
              image_tag slide.image
            end
            column :text
            column :link_url, label: 'Link URL'
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
          input :headline
          input :apartment_subheadline
          input :home_subheadline
          input :body, as: :redactor
          input :body_sub_image, as: :image
          input :mobile_title
          input :mobile_banner_image, as: :image
          input :mobile_body, as: :redactor
        end

        tab 'Slides' do
          has_many :slides, heading: false, allow_destroy: true do |slide|
            slide.input :image, as: :image
            slide.input :call_to_action
            slide.input :link_url
            slide.input :description
          end
        end

        tab 'Home Section' do
          has_many :home_section_slides, heading: 'Images', allow_destroy: true do |slide|
            slide.input :image, as: :image
            slide.input :text
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
