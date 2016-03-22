class AddStackTraceToPropertyFeedImports < ActiveRecord::Migration
  def change
    add_column :property_feed_imports, :stack_trace, :text
  end
end
