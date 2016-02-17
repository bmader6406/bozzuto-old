ActiveAdmin.register Page do
  menu parent: 'Ronin'

  permit_params :title,
                :section,
                :section_id,
                :parent,
                :parent_id,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :body,
                :mobile_body,
                :mobile_body_extra,
                :left_montage_image,
                :middle_montage_image,
                :right_montage_image,
                :snippet,
                :snippet_id

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Page.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  filter :title_cont, label: 'Title'

  index do
    column :title
    column :published
    column :section

    actions
  end

  form do |f|
    inputs do
      input :title
      input :section
      input :parent
      input :published
      input :show_sidebar
      input :show_in_sidebar_nav
      input :meta_title
      input :meta_description
      input :meta_keywords
      input :body
      input :mobile_body
      input :mobile_body_extra
      input :left_montage_image
      input :middle_montage_image
      input :right_montage_image
      input :snippet
    end

    actions
  end
end
