class CreateSearchResultProxies < ActiveRecord::Migration
  def change
    create_table :search_result_proxies do |t|
      t.string :query, null: false
      t.string :url, null: false
      t.timestamps null: false
    end
  end
end
