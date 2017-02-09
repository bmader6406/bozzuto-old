AlgoliaSearch.configuration = {
  application_id:     Rails.application.secrets.algolia_app_id,
  api_key:            Rails.application.secrets.algolia_api_key,
  pagination_backend: :kaminari
}

DEFAULT_ALGOLIA_OPTIONS = {
  per_environment:     true,
  index_name:          'bozzutosite'.freeze,
  id:                  :algolia_id,
  force_utf8_encoding: true,
  sanitize:            true,
  pagination_backend:  :kaminari,
  synchronous:         Rails.env.test?,
  per_page:            20
}.freeze

AlgoliaSearch::IndexSettings.class_eval do
  def has_many_attribute(relationship, attribute_name)
    attribute relationship do
      self.public_send(relationship).map(&attribute_name).join(', ')
    end
  end

  def has_one_attribute(relationship, attribute_name)
    attribute relationship do
      self.public_send(relationship).try(attribute_name)
    end
  end
end

AlgoliaSearch::Utilities.define_singleton_method(:reindex_all_models) do
  get_model_classes.each do |klass|
    puts klass.name
    klass.reindex!
  end
end
