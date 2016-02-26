ActiveAdmin.register SeoMetadata do
  menu false

  permit_params :resource_id,
                :resource_type,
                :meta_title,
                :meta_keywords,
                :meta_description
end
