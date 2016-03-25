class DropCareersEntries < ActiveRecord::Migration
  def change
    drop_table :careers_entries do
      t.string :name,                     :null => false
      t.string :company,                  :null => false
      t.string :job_title,                :null => false
      t.text   :job_description
      t.string :main_photo_file_name
      t.string :main_photo_content_type
      t.string :headshot_file_name
      t.string :headshot_content_type
      t.string :youtube_url
      t.integer :position

      t.timestamps
    end
  end
end
