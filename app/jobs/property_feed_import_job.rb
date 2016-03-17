class PropertyFeedImportJob
  @queue = :property_feed_imports

  def self.perform(property_feed_import_id)
    new(property_feed_import_id).perform
  end

  def initialize(import_id)
    @import_id = import_id
  end

  def perform
    importer.call
  end

  private

  attr_reader :import_id

  def import
    @import ||= PropertyFeedImport.find(import_id)
  end

  def importer
    @importer ||= "#{namespace}::Importer".constantize.new(import)
  end

  def source
    import.type.classify
  end

  def namespace
    "Bozzuto::ExternalFeed::#{source}"
  end
end
