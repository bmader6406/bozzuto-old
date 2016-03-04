class CreateFileUploads < ActiveRecord::Migration
  def change
    create_table :file_uploads do |t|
      t.string :file_file_name
      t.string :file_content_type

      t.timestamps null: false
    end
  end
end
