namespace :algoliasearch do
  desc "Setup Index settings"
  task :set_index_settings => :environment do
    index = Algolia::Index.new("#{DEFAULT_ALGOLIA_OPTIONS[:index_name]}_#{Rails.env.to_s}")
    index.set_settings("searchableAttributes" => %w[
      name
      title
      header_title
      company
      state
      city
      unordered(body)
      unordered(bio)
      unordered(detail_description)
      unordered(listing_text)
      unordered(description)
      unordered(neighborhood_description)
      unordered(overview_text)
      unordered(leadership_groups)
      unordered(property_features)
      unordered(property_amenities)
      zip_code
    ])
  end
end
