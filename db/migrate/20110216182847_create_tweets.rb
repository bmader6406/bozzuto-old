class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string   :tweet_id, :null => false
      t.text     :text, :null => false
      t.datetime :posted_at, :null => false
      t.integer  :twitter_account_id, :null => false

      t.timestamps
    end

    add_index :tweets, :twitter_account_id
    add_index :tweets, :tweet_id
  end

  def self.down
    remove_index :tweets, :tweet_id
    remove_index :tweets, :twitter_account_id

    drop_table :tweets
  end
end
