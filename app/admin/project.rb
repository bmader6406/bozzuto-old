ActiveAdmin.register Project do
  menu parent: 'Properties'

  permit_params :title,
                :short_title,
                :short_description,
                :page_header,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :section,
                :section_id,
                :street_address,
                :city,
                :county,
                :zip_code,
                :latitude,
                :longitude,
                :website_url,
                :website_url_text,
                :video_url,
                :brochure_link_text,
                :brochure_type,
                :brochure_url,
                :brochure,
                :listing_image,
                :listing_title,
                :listing_text,
                :overview_text,
                :published,
                :featured_mobile

  filter :title_cont,          label: 'Title'
  filter :street_address_cont, label: 'Street Address'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Property.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
    column :title
    column :published
    column :street_address
    column :city
    column :section

    actions
  end

  form do |f|
    inputs do
      input :title
      input :short_title
      input :short_description
      input :page_header
      input :has_completion_date
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :section
      input :street_address
      input :city
      input :county
      input :zip_code
      input :latitude
      input :longitude
      input :website_url
      input :website_url_text
      input :video_url
      input :brochure_link_text
      input :brochure_type
      input :brochure_url
      input :brochure
      input :listing_image
      input :listing_title
      input :listing_text
      input :overview_text
      input :published
      input :featured_mobile
    end

    actions
  end
end
