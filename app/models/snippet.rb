class Snippet < ActiveRecord::Base
  validates_presence_of :name, :body
  validates_uniqueness_of :name

  def self.typus_description
    "Blocks of text that may appear multiple times throughout the site."
  end
end
