class CreateContactTopics < ActiveRecord::Migration
  def self.up
    create_table :contact_topics do |t|
      t.string  :topic, :null => false
      t.text    :body
      t.string  :recipients, :null => false
      t.integer :section_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_topics
  end
end
