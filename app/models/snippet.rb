class Snippet < ActiveRecord::Base

  has_many :pages

  validates_presence_of   :name, :body
  validates_uniqueness_of :name
end
